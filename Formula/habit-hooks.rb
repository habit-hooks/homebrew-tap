class HabitHooks < Formula
  include Language::Python::Virtualenv

  desc "Structural code-smell coaching for AI agents"
  homepage "https://github.com/habit-hooks/habit-hooks"
  url "https://files.pythonhosted.org/packages/ab/9f/5dc2c642950785c9787804b9075383986222c426549432f0f0ec83266287/habit_hooks-1.2.1.tar.gz"
  sha256 "72a610aebff39e68bd1f56d61868e68b4cab01d056056604940206c561c406af"
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
    url "https://files.pythonhosted.org/packages/7b/c7/eaf9b76096226f2eaa9f13ee2bf295424908d839e2d8de98bbff40dc4396/habit_hooks_generic-1.2.1.tar.gz"
    sha256 "9449250704af3ab0fc1e692befdd2e7f94c5ebef6a14e6c33b26bd6d2ed19d24"
  end

  resource "habit-hooks-php" do
    url "https://files.pythonhosted.org/packages/63/4c/3d8d5b0cbe476d927bfc7cc7c1f884b0ab2a72370f5328ce3f8217b81287/habit_hooks_php-1.2.1.tar.gz"
    sha256 "3aab4dcb431b57c7601a17ca67d7e8876eacaea6fca287ebf8ea0ece92a7bfbe"
  end

  resource "habit-hooks-python" do
    url "https://files.pythonhosted.org/packages/69/85/2d310d8cd44daac7e289f8430d98baf4f15fb4d18f9d8f575d5962f51eba/habit_hooks_python-1.2.1.tar.gz"
    sha256 "cbd974445db8be3a9f88cb3e4d6cd2a3a27d91bff828a32b4244d26529f30682"
  end

  resource "habit-hooks-typescript" do
    url "https://files.pythonhosted.org/packages/1b/9f/73dd1b5d3c1a993d5658f1187897adece9eceff886c7dd0df1a5020fdaf7/habit_hooks_typescript-1.2.1.tar.gz"
    sha256 "843bebd5fe5ba3cbb7dec1447ecaed67a7e7d607bd4b3ff535903adc0f19c827"
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
    assert_equal "['generic', 'php', 'python', 'typescript']\n",
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
