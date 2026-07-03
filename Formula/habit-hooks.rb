class HabitHooks < Formula
  include Language::Python::Virtualenv

  desc "Structural code-smell coaching for AI agents"
  homepage "https://github.com/habit-hooks/habit-hooks"
  url "https://files.pythonhosted.org/packages/e8/9b/95ff14339e8a4be5579f1370ef43d02012eb9864689e3f2486f3d0507e9b/habit_hooks-1.0.1.tar.gz"
  sha256 "6cec760ceaf15ccc299f728facdc32a29a4dfee876757f0b53995fc0393a71fd"
  license "MIT"

  livecheck do
    url :stable
    strategy :pypi
  end

  bottle do
    root_url "https://github.com/habit-hooks/homebrew-tap/releases/download/habit-hooks-1.0.1"
    sha256 cellar: :any, arm64_tahoe:  "ac621a6e507817ece4cdfa36afb8fa9c75412c820973a43928143fc2aad1e2b8"
    sha256 cellar: :any, x86_64_linux: "54829b3c0116c8f07a8069006712329a7a65caa91014515b00ee401105822eae"
  end

  depends_on "rust" => :build
  depends_on "python@3.13"

  resource "annotated-types" do
    url "https://files.pythonhosted.org/packages/ee/67/531ea369ba64dcff5ec9c3402f9f51bf748cec26dde048a2f973a4eea7f5/annotated_types-0.7.0.tar.gz"
    sha256 "aff07c09a53a08bc8cfccb9c85b05f1aa9a2a6f23728d790723543408344ce89"
  end

  resource "habit-hooks-generic" do
    url "https://files.pythonhosted.org/packages/3d/79/8cd6e803b769e0f6ff2a03e77d6f2a12bd5ed4bd649fd744713c0e04ba81/habit_hooks_generic-1.0.1.tar.gz"
    sha256 "a7751eab2fc41ff11ccab7268ccbb38c89b844102314f720cf63ae27b4bdd1c3"
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

  resource "pydantic" do
    url "https://files.pythonhosted.org/packages/18/a5/b60d21ac674192f8ab0ba4e9fd860690f9b4a6e51ca5df118733b487d8d6/pydantic-2.13.4.tar.gz"
    sha256 "c40756b57adaa8b1efeeced5c196f3f3b7c435f90e84ea7f443901bec8099ef6"
  end

  resource "pydantic-core" do
    url "https://files.pythonhosted.org/packages/9d/56/921726b776ace8d8f5db44c4ef961006580d91dc52b803c489fafd1aa249/pydantic_core-2.46.4.tar.gz"
    sha256 "62f875393d7f270851f20523dd2e29f082bcc82292d66db2b64ea71f64b6e1c1"
  end

  resource "typing-extensions" do
    url "https://files.pythonhosted.org/packages/f6/cc/6253133b5bb138fc3306cebfbda2c520f545d36b5be2c7255cc528bb45d6/typing_extensions-4.16.0.tar.gz"
    sha256 "dc983d19a509c94dba722ee6abd33940f7c05a89e243c47e907eb4db6f1a43e5"
  end

  resource "typing-inspection" do
    url "https://files.pythonhosted.org/packages/55/e3/70399cb7dd41c10ac53367ae42139cf4b1ca5f36bb3dc6c9d33acdb43655/typing_inspection-0.4.2.tar.gz"
    sha256 "ba561c48a67c5958007083d386c3295464928b01faa735ab8547c5692e87f464"
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
