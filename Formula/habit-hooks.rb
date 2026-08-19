class HabitHooks < Formula
  include Language::Python::Virtualenv

  desc "Structural code-smell coaching for AI agents"
  homepage "https://github.com/habit-hooks/habit-hooks"
  url "https://files.pythonhosted.org/packages/60/41/4e53d203fb44f2de57c4eb207fc81edd0bc6e68b8b56db1f6a8f235e5f05/habit_hooks-1.3.0.tar.gz"
  sha256 "e30bc90227c17e3be07636c8c25fb013f5979e566ea7d14780f3fa7a9edd41f9"
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
    url "https://files.pythonhosted.org/packages/e6/48/21d65d95a2cd189333070cab358b4b683615f75af2e09ea23bcea04f65fc/habit_hooks_generic-1.3.0.tar.gz"
    sha256 "253f3de205516956a874312ce18be1183f3fe4fa7899745cfa4ad6cadeb93925"
  end

  resource "habit-hooks-java" do
    url "https://files.pythonhosted.org/packages/c8/26/2e79d65329ad8b1558a3e9374404ab9071397a65dac1074351c96eec4f59/habit_hooks_java-1.3.0.tar.gz"
    sha256 "d436110cea4c18fcfffdda339baddaaabd9a89b8362aa1d32475d5e8589487d3"
  end

  resource "habit-hooks-php" do
    url "https://files.pythonhosted.org/packages/c9/9f/e77d6634b9c7da71f45c67c519ec091fdea17bc1ebe47c1523cad5dfcd3e/habit_hooks_php-1.3.0.tar.gz"
    sha256 "6ea6100225ac9dff7be540d4e77f5c2a75d5d3bce4461c00c2a2263c69147ae6"
  end

  resource "habit-hooks-python" do
    url "https://files.pythonhosted.org/packages/26/d3/347340912422dda00971c737cfdd78feb1f91c856d66643eba1b61417f91/habit_hooks_python-1.3.0.tar.gz"
    sha256 "a8d05c506be81399d4cc7264d18fde9e85d74c8bfa84c8ff4b9be8aa25c024ba"
  end

  resource "habit-hooks-typescript" do
    url "https://files.pythonhosted.org/packages/1d/0e/db70eda361038153f02bbc8c6caf6a95bdda8776586beffe5d6413950ccd/habit_hooks_typescript-1.3.0.tar.gz"
    sha256 "b1cf3e7bf0b0cbc422ae91934b9c3456a4023d3f42a4d8608813cd477684baed"
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
