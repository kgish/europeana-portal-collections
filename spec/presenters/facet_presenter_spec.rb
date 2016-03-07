RSpec.describe FacetPresenter do
  def facet_items(count)
    (1..count).map do |n|
      Europeana::Blacklight::Response::Facets::FacetItem.new(value: "Item#{n}", hits: (count + 1 - n) * 100)
    end
  end

  let(:controller) do
    PortalController.new.tap do |controller|
      controller.request = ActionController::TestRequest.new
      params.each_pair do |k, v|
        controller.request.parameters[k] = v
      end
    end
  end

  let(:params) { {} }

  let(:blacklight_config) do
    Blacklight::Configuration.new do |config|
      config.add_facet_field 'SIMPLE_FIELD'
      config.add_facet_field 'HIERARCHICAL_PARENT_FIELD', hierarchical: true
      config.add_facet_field 'HIERARCHICAL_CHILD_FIELD', hierarchical: true, parent: 'HIERARCHICAL_PARENT_FIELD'
      config.add_facet_field 'BOOLEAN_FIELD', boolean: true
      config.add_facet_field 'COLOUR_FIELD', colour: true
      config.add_facet_field 'RANGE_FIELD', range: true
      config.add_facet_field 'SINGLE_SELECT_FIELD', single: true
    end
  end

  let(:facet_field_class) { Europeana::Blacklight::Response::Facets::FacetField }

  describe '.build' do
    subject { described_class.build(facet, controller, blacklight_config) }

    context 'when facet is a simple field' do
      let(:facet) { facet_field_class.new('SIMPLE_FIELD', []) }
      it { is_expected.to be_a(Facet::SimplePresenter) }
    end

    context 'when facet is a hierarchical field' do
      context 'with no parent' do
        let(:facet) { facet_field_class.new('HIERARCHICAL_PARENT_FIELD', []) }
        it { is_expected.to be_a(Facet::HierarchicalPresenter) }
      end
      context 'with a parent' do
        let(:facet) { facet_field_class.new('HIERARCHICAL_CHILD_FIELD', []) }
        it { is_expected.to be_a(Facet::SimplePresenter) }
      end
    end

    context 'when facet is a boolean field' do
      let(:facet) { facet_field_class.new('BOOLEAN_FIELD', []) }
      it { is_expected.to be_a(Facet::BooleanPresenter) }
    end

    context 'when facet is a colour field' do
      let(:facet) { facet_field_class.new('COLOUR_FIELD', []) }
      it { is_expected.to be_a(Facet::ColourPresenter) }
    end

    context 'when facet is a range field' do
      let(:facet) { facet_field_class.new('RANGE_FIELD', []) }
      it { is_expected.to be_a(Facet::RangePresenter) }
    end
  end

  describe '#display' do
    let(:facet) { facet_field_class.new('SIMPLE_FIELD', []) }
    let(:options) { {} }
    subject { described_class.new(facet, controller, blacklight_config).display(options) }

    it { is_expected.to be_a(Hash) }

    it 'should include a translated title' do
      I18n.backend.store_translations(:en, global: { facet: { header: { simple_field: 'simple field title' } } })
      expect(subject[:title]).to eq('simple field title')
    end

    context 'when facet is single-select' do
      let(:facet) { facet_field_class.new('SINGLE_SELECT_FIELD', []) }

      it 'should include select_one: true' do
        expect(subject[:select_one]).to be(true)
      end
    end

    context 'when facet is not single-select' do
      it 'should include select_one: nil' do
        expect(subject[:select_one]).to be_nil
      end
    end

    context 'when options[:count] is 4 and facet has 6 items' do
      let(:options) { { count: 4 } }
      let(:items) { facet_items(6) }
      let(:facet) { facet_field_class.new('SIMPLE_FIELD', items) }

      context 'with no facet items not in request params' do
        it 'should have 4 unhidden items' do
          expect(subject[:items].length).to eq(4)
        end

        it 'should have 2 hidden items' do
          expect(subject[:extra_items][:items].length).to eq(2)
        end
      end

      context 'with 5 facet items in request params' do
        let(:params) { { f: { facet.name => items[0..4].map(&:value) } } }

        it 'should have 5 unhidden items' do
          expect(subject[:items].length).to eq(5)
        end

        it 'should have 1 hidden item' do
          expect(subject[:extra_items][:items].length).to eq(1)
        end
      end
    end
  end

  describe '#facet_item' do
    let(:facet) { facet_field_class.new('SIMPLE_FIELD', []) }
    let(:item) { facet_items(10).first }
    subject { described_class.new(facet, controller, blacklight_config).facet_item(item) }

    it 'should include a translated, capitalized label' do
      I18n.backend.store_translations(:en, global: { facet: { simple_field: { item1: 'item label' } } })
      expect(subject[:text]).to eq('Item Label')
    end

    it 'should include a formatted number of results' do
      expect(subject[:num_results]).to eq('1,000')
    end

    context 'when item is not in request params' do
      it 'should include URL to add facet' do
        expect(subject[:url]).to match(facet.name)
      end

      it 'should indicate facet not checked' do
        expect(subject[:is_checked]).to be(false)
      end
    end

    context 'when item is in request params' do
      let(:params) { { f: { facet.name => [item.value] } } }

      it 'should include URL to remove facet' do
        expect(subject[:url]).not_to match(facet.name)
      end

      it 'should indicate facet checked' do
        expect(subject[:is_checked]).to be(true)
      end
    end
  end

  describe '#filter_item' do
    let(:facet) { facet_field_class.new('SIMPLE_FIELD', []) }
    let(:item) { facet_items(10).first }
    subject { described_class.new(facet, controller, blacklight_config).filter_item(item) }
    let(:params) { { f: { facet.name => [item.value] } } }

    it 'should include a translated facet title' do
      I18n.backend.store_translations(:en, global: { facet: { header: { simple_field: 'simple field title' } } })
      expect(subject[:filter]).to eq('simple field title')
    end

    it 'should include a translated, capitalized item label' do
      I18n.backend.store_translations(:en, global: { facet: { simple_field: { item1: 'item label' } } })
      expect(subject[:value]).to eq('Item Label')
    end

    it 'should include URL to remove facet' do
      expect(subject[:remove]).not_to match(facet.name)
    end

    it 'should include facet URL param name' do
      expect(subject[:name]).to eq("f[#{facet.name}][]")
    end
  end
end
