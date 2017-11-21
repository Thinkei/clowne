describe Clowne::Adapters::ActiveRecord::Associations::HABTM, :cleanup, adapter: :active_record do
  let(:source) { create(:post, :with_tags, tags_num: 2) }
  let(:record) { Post.new }
  let(:reflection) { Post.reflections['tags'] }
  let(:scope) { {} }
  let(:declaration_params) { {} }
  let(:declaration) { Clowne::Declarations::IncludeAssociation.new(:tags, scope, **declaration_params) }
  let(:params) { {} }
  let(:traits) { [] }

  subject(:resolver) { described_class.new(reflection, source, declaration, params, traits) }

  describe '.call' do
    subject { resolver.call(record) }

    it 'clones all the tags withtout cloner' do
      expect(subject.tags.size).to eq 2
      expect(subject.tags.first).to have_attributes(
        value: source.tags.first.value
      )
      expect(subject.tags.second).to have_attributes(
        value: source.tags.second.value
      )
    end

    context 'with scope' do
      let(:scope) { ->(params) { where(value: params[:with_tag]) if params[:with_tag] } }
      let(:params) { { with_tag: source.tags.second.value } }

      it 'clones scoped children' do
        expect(subject.tags.size).to eq 1
        expect(subject.tags.first).to have_attributes(
          value: source.tags.second.value
        )
      end
    end

    context 'with custom cloner' do
      let(:tag_cloner) do
        Class.new(Clowne::Cloner) do
          finalize do |_source, record, params|
            record.value += params.fetch(:suffix, '-2')
          end

          trait :mark_as_clone do
            finalize do |_source, record|
              record.value += ' (Cloned)'
            end
          end
        end
      end

      let(:declaration_params) { { clone_with: tag_cloner } }

      it 'applies custom cloner' do
        expect(subject.tags.size).to eq 2
        expect(subject.tags.first).to have_attributes(
          value: "#{source.tags.first.value}-2"
        )
      end

      context 'with params' do
        let(:params) { { suffix: '-new' } }

        it 'pass params to child cloner' do
          expect(subject.tags.size).to eq 2
          expect(subject.tags.first).to have_attributes(
            value: "#{source.tags.first.value}-new"
          )
        end
      end

      xcontext 'with traits' do
        let(:traits) { [:mark_as_clone] }

        it 'pass traits to child cloner' do
          expect(subject.tags.size).to eq 2
          expect(subject.tags.first).to have_attributes(
            value: "#{source.tags.first.value}-2 (Cloned)"
          )
        end
      end
    end
  end
end
