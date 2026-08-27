class HabitHooks < Formula
  include Language::Python::Virtualenv

  desc "Structural code-smell coaching for AI agents"
  homepage "https://github.com/habit-hooks/habit-hooks"
  url "https://files.pythonhosted.org/packages/13/dd/011ebd3af2e5835329fda3b39cc268ad8b94b86e4b4126f283af4ab483aa/habit_hooks-1.4.0.tar.gz"
  sha256 "a18215d6eb8380ddb152cdd3c02a839bb3c84b2fad0254d7060883286b56584b"
  license "MIT"

  livecheck do
    url :stable
    strategy :pypi
  end

  depends_on "python@3.13"

  resource "attrs" do
    url "https://files.pythonhosted.org/packages/9a/8e/82a0fe20a541c03148528be8cac2408564a6c9a0cc7e9171802bc1d26985/attrs-26.1.0.tar.gz"
    sha256 "d03ceb89cb322a8fd706d4fb91940737b6642aa36998fe130a9bc96c985eff32"
  end

  resource "habit-hooks-generic" do
    url "https://files.pythonhosted.org/packages/0b/4a/7e027f85f96abf6ca8fecc9296b3e731799a9ffded1be358e1adbea0adab/habit_hooks_generic-1.4.0.tar.gz"
    sha256 "fce66b2215bff76b38b0aebffcbd7b93522c350ed7b7690b03d18088ed09eeb8"
  end

  resource "habit-hooks-java" do
    url "https://files.pythonhosted.org/packages/7f/9f/85f8215a23559326b905fdfa7b5cb936b6eaa88769883c14f9973d83d87c/habit_hooks_java-1.4.0.tar.gz"
    sha256 "88ea9bf6dd549bd230b36419c965e64b075d3b03c124e3aca633b96702429054"
  end

  resource "habit-hooks-php" do
    url "https://files.pythonhosted.org/packages/6d/e6/b171c39fa30ade066e51cb8e5860a692543ec3ece6466a2419c79b07e709/habit_hooks_php-1.4.0.tar.gz"
    sha256 "52c6ed3116bac539c2bff0d7b024ece8597840268f32549688075c02b44c303d"
  end

  resource "habit-hooks-python" do
    url "https://files.pythonhosted.org/packages/34/7c/3b5eaad9402f07f4043941386c58f48d96315c2236501372ad3f1240f04d/habit_hooks_python-1.4.0.tar.gz"
    sha256 "0e52f57fc4be347bb326a09c814a5553bbc88e9719abba0279997b23d8888169"
  end

  resource "habit-hooks-typescript" do
    url "https://files.pythonhosted.org/packages/84/c0/efbb5295e49d3ed6621b45b38ce4d9ecd2b2870ec2f8f7f29ebca8c81c6d/habit_hooks_typescript-1.4.0.tar.gz"
    sha256 "82e42d3ac363f1a64e7cec6c44fc4bf8ca1b6d41b54df9aad32acf67a3557993"
  end

  resource "jinja2" do
    url "https://files.pythonhosted.org/packages/df/bf/f7da0350254c0ed7c72f3e33cef02e048281fec7ecec5f032d4aac52226b/jinja2-3.1.6.tar.gz"
    sha256 "0137fb05990d35f1275a587e9aee6d56da821fc83491a0fb838183be43f66d6d"
  end

  resource "markupsafe" do
    url "https://files.pythonhosted.org/packages/7e/99/7690b6d4034fffd95959cbe0c02de8deb3098cc577c67bb6a24fe5d7caa7/markupsafe-3.0.3.tar.gz"
    sha256 "722695808f4b6457b320fdc131280796bdceb04ab50fe1795cd540799ebe1698"
  end

  resource "pathspec" do
    url "https://files.pythonhosted.org/packages/5a/82/42f767fc1c1143d6fd36efb827202a2d997a375e160a71eb2888a925aac1/pathspec-1.1.1.tar.gz"
    sha256 "17db5ecd524104a120e173814c90367a96a98d07c45b2e10c2f3919fff91bf5a"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    # Every language plugin ships with the formula, so `brew install` alone is a
    # working setup. Installing one by hand into the Cellar venv was the
    # workaround this replaces, and it does not survive the next upgrade.
    (testpath/"plugins.py").write <<~PYTHON
      from importlib.metadata import entry_points

      print(sorted(plugin.name for plugin in entry_points(group="habit_hooks.plugins")))
    PYTHON
    assert_equal "['generic', 'java', 'php', 'python', 'typescript']\n",
                 shell_output("#{libexec}/bin/python #{testpath}/plugins.py")

    (testpath/".habit-hooks").mkpath
    (testpath/".habit-hooks/config.toml").write <<~TOML
      plugins = ["generic"]
      files = ["**/*.py"]

      [sensors.jscpd]
      disabled = true
    TOML
    (testpath/"big.py").write(Array.new(205) { |i| "x#{i} = 0" }.join("\n") + "\n")
    output = shell_output("#{bin}/habit-sensors --all")
    assert_match "oversized-file", output
  end
end
