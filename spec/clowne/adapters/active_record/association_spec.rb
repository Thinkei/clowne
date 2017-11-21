describe Clowne::Adapters::ActiveRecord::Association do
  let(:params) { double }
  let(:traits) { double }
  let(:record) { double }
  let(:association) {}
  let(:source) { build_stubbed(:post) }
  let(:declaration) { Clowne::Declarations::IncludeAssociation.new(association) }

  subject { described_class.call(source, record, declaration, params: params, traits: traits) }

  context 'with has_many' do
    let(:association) { :posts }
    let(:source) { build_stubbed(:user) }

    it 'uses HasMany resolver' do
      expect(Clowne::Adapters::ActiveRecord::Associations::HasMany).to receive(:new).with(
        User.reflections['posts'], source, declaration, params, traits
      ) do
        double.tap do |resolver|
          expect(resolver).to receive(:call).with(record)
        end
      end

      subject
    end
  end

  context 'with has_many through' do
    let(:association) { :accounts }
    let(:source) { build_stubbed(:user) }

    it 'uses Noop resolver' do
      expect(Clowne::Adapters::ActiveRecord::Associations::Noop).to receive(:new).with(
        User.reflections['accounts'], source, declaration, params, traits
      ) do
        double.tap do |resolver|
          expect(resolver).to receive(:call).with(record)
        end
      end

      subject
    end
  end

  context 'with has_one' do
    let(:association) { :account }

    it 'uses HasOne resolver' do
      expect(Clowne::Adapters::ActiveRecord::Associations::HasOne).to receive(:new).with(
        Post.reflections['account'], source, declaration, params, traits
      ) do
        double.tap do |resolver|
          expect(resolver).to receive(:call).with(record)
        end
      end

      subject
    end
  end

  context 'with has_one through' do
    let(:association) { :history }

    it 'uses Noop resolver' do
      expect(Clowne::Adapters::ActiveRecord::Associations::Noop).to receive(:new).with(
        Post.reflections['history'], source, declaration, params, traits
      ) do
        double.tap do |resolver|
          expect(resolver).to receive(:call).with(record)
        end
      end

      subject
    end
  end

  context 'with belongs_to' do
    let(:association) { :topic }

    it 'uses Noop resolver' do
      expect(Clowne::Adapters::ActiveRecord::Associations::Noop).to receive(:new).with(
        Post.reflections['topic'], source, declaration, params, traits
      ) do
        double.tap do |resolver|
          expect(resolver).to receive(:call).with(record)
        end
      end

      subject
    end
  end

  context 'with HABTM' do
    let(:association) { :tags }

    it 'uses HABTM resolver' do
      expect(Clowne::Adapters::ActiveRecord::Associations::HABTM).to receive(:new).with(
        Post.reflections['tags'], source, declaration, params, traits
      ) do
        double.tap do |resolver|
          expect(resolver).to receive(:call).with(record)
        end
      end

      subject
    end
  end
end
