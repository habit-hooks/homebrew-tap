class HabitHooks < Formula
  include Language::Python::Virtualenv

  desc "Structural code-smell coaching for AI agents"
  homepage "https://github.com/habit-hooks/habit-hooks"
  url "https://files.pythonhosted.org/packages/cd/df/cfc89468e51be615fc7f0373625a4f967164fba4848d16d4b18ea245bc53/habit_hooks-1.1.0.tar.gz"
  sha256 "aa486e0c884ebbd4fd9551f39ff4729ed086162c22cd973cf355999da511adb0"
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
    url "https://files.pythonhosted.org/packages/2d/16/e6ab4353a856eeec99de23afaeba788421ad351def70fc6f76c306b16b2e/habit_hooks_generic-1.1.0.tar.gz"
    sha256 "ebd4521b3ce406f79daf353e227edd0bb39448e542c08fa0392816001a5467f8"
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
