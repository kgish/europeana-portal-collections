RSpec.describe MarkdownHelper do
  describe '#markdown' do
    let(:markdown_text) { 'Mark it *down!*' }
    subject { helper.markdown(markdown_text) }
    it 'should convert Markdown to HTML' do
      expect(subject).to eq("<p>Mark it <em>down!</em></p>\n")
    end
  end
end
