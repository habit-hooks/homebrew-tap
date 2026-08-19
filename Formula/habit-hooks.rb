class HabitHooks < Formula
  include Language::Python::Virtualenv

  desc "Structural code-smell coaching for AI agents"
  homepage "https://github.com/habit-hooks/habit-hooks"
  url "https://files.pythonhosted.org/packages/f1/a4/4ea56228c3674f838c3d86981f7d8fe7378fa27602bba098019a51b3726f/habit_hooks-1.3.1.tar.gz"
  sha256 "34d7c4f3774a29f6275866afc2f993a4c6fedabe036f1ceba858fffce5d0a69f"
  license "MIT"

  livecheck do
    url :stable
    strategy :pypi
  end

  bottle do
    root_url "https://github.com/habit-hooks/homebrew-tap/releases/download/habit-hooks-1.3.1"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0ffaf8694ea016d260958c9e4ab030b8a8911303f5b9c19bbdeec0d7c0324a44"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fa55ca3da6da567fbc87c109b4a5394334eb5a992e2f3da5291af1f17b9432df"
    sha256 cellar: :any_skip_relocation, sequoia:       "efe65d8ac95651dec0eff6d71cc683d6822eb73bc3cfd22cc3aae95b170808a0"
    sha256 cellar: :any,                 x86_64_linux:  "a50ddeefd2a676a1576ea0189d70ad367b0be7a7dcfa92d5c9aa82de05a7a569"
  end

  depends_on "python@3.13"

  resource "attrs" do
    url "https://files.pythonhosted.org/packages/9a/8e/82a0fe20a541c03148528be8cac2408564a6c9a0cc7e9171802bc1d26985/attrs-26.1.0.tar.gz"
    sha256 "d03ceb89cb322a8fd706d4fb91940737b6642aa36998fe130a9bc96c985eff32"
  end

  resource "habit-hooks-generic" do
    url "https://files.pythonhosted.org/packages/14/c2/c92e32e87a4c487fd0c9d0c6c138b0c4f9c1928dd3e9c93e602a33f519b5/habit_hooks_generic-1.3.1.tar.gz"
    sha256 "862d57e38c3ee0295b26c2e67e040528f6e00d7e250f7049c7df43f08360a320"
  end

  resource "habit-hooks-java" do
    url "https://files.pythonhosted.org/packages/61/98/88eede9e3498f9ae5a312100dea09cd9bba6d6ba2201114a1e8c5820fe67/habit_hooks_java-1.3.1.tar.gz"
    sha256 "8d886001b4942e04bd44a52149888e98270c003231aded2cd605f7dc00366c75"
  end

  resource "habit-hooks-php" do
    url "https://files.pythonhosted.org/packages/5c/fe/18fad24467a5f2d1f75335240f15c59c6e47e3d12a0de4d6a3c2ec80b1b0/habit_hooks_php-1.3.1.tar.gz"
    sha256 "3f045b6d2214d5d6a7d911cbda615a5a54f87b70f031ce7b61f8d251c21062c5"
  end

  resource "habit-hooks-python" do
    url "https://files.pythonhosted.org/packages/09/df/757d4586fb2cf3c2f366b59535d41cd73e96f1068636a73ffebd88c675b7/habit_hooks_python-1.3.1.tar.gz"
    sha256 "dd936f69281ce6a7a7e7c8762a63c681700797e594bc9f3dac5bceb033c7a627"
  end

  resource "habit-hooks-typescript" do
    url "https://files.pythonhosted.org/packages/de/b0/e8872f5e24702f90fd603d8c315e6a2faea6b43ee719b2b93e2a25faa769/habit_hooks_typescript-1.3.1.tar.gz"
    sha256 "8095466de43a2e97f8016849e813f08dcafc6d04cc84f76ce90dfd7a3e802dac"
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
