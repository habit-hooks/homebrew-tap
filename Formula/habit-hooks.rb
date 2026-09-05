class HabitHooks < Formula
  include Language::Python::Virtualenv

  desc "Structural code-smell coaching for AI agents"
  homepage "https://github.com/habit-hooks/habit-hooks"
  url "https://files.pythonhosted.org/packages/d1/85/5c9dbc0c042e7a1afb6a7c0d356d6eaa6276e4a73dc26146d6fb7422f45d/habit_hooks-1.5.0.tar.gz"
  sha256 "1e06ae07796ab0015afd3b13c53f3a8d92ac639fcdc04af82c8a9a4d6dfb32d3"
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
    url "https://files.pythonhosted.org/packages/3b/06/08f357aa4bc8958dada5991c02467a9afd51b9347ae0b876f34e3ee846bf/habit_hooks_generic-1.5.0.tar.gz"
    sha256 "ded020f88a96fd2f7b23d79937b33f27879151b74973bb77fcf9e196b53bdbd9"
  end

  resource "habit-hooks-java" do
    url "https://files.pythonhosted.org/packages/07/53/048f3cf992def1e5cfcf5265960f7797962aaae43ed6a47aa605659b2fe0/habit_hooks_java-1.5.0.tar.gz"
    sha256 "b52da7bd890b3f14df4ef27f98263c37563640c69202a63fc3fe71af4cab4b78"
  end

  resource "habit-hooks-php" do
    url "https://files.pythonhosted.org/packages/68/66/0d1d076cd896ba64008fd8004f7eb3240b86ceff73a578b55e9ebe7e1e72/habit_hooks_php-1.5.0.tar.gz"
    sha256 "272cca3a4384f66bddf0623f0b25d7b671a9c31396fc51651ad458132dbd41b4"
  end

  resource "habit-hooks-python" do
    url "https://files.pythonhosted.org/packages/b8/a0/895638bdbdc449660f2a4117a8eefa571496b0a1905c95684fb86ff1ee78/habit_hooks_python-1.5.0.tar.gz"
    sha256 "6d62079e2d44f4f2b886c12b2c13326876fc7907c13711a0b1b96e93b0338c9c"
  end

  resource "habit-hooks-ruby" do
    url "https://files.pythonhosted.org/packages/42/14/fba44e3dd7efdee3623b40a0ab6f5983cb6b2ba229d6987b0f18b8a59092/habit_hooks_ruby-1.5.0.tar.gz"
    sha256 "50ff3393bca89a3b8b094d97689f4a74424a668c5dc1416ae249d39920eac6c6"
  end

  resource "habit-hooks-typescript" do
    url "https://files.pythonhosted.org/packages/ad/51/1e9e8f017d9e56a67725a45979d57c4d64df8d748ad5ddb74f18e7d85ae2/habit_hooks_typescript-1.5.0.tar.gz"
    sha256 "70d9fe4a95ad811e4d4cfa199090194ff90d52000604e540614eb3cc733d9d2c"
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
    assert_equal "['generic', 'java', 'php', 'python', 'ruby', 'typescript']\n",
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
