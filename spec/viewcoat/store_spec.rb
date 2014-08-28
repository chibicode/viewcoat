require "spec_helper"

describe Viewcoat::Store do
  describe "#with" do
    it "stores dictionary and makes it available inside the block" do
      subject.with({ a: 1 }) do
        expect(subject.a).to eq(1)
      end
    end

    it "does not make the dictionary available outside the block" do
      subject.with({ a: 1 })
      expect {
        subject.a
      }.to raise_error
    end

    it "returns nil so it can be used with <%= ... %>" do
      expect(subject.with({ a: 1 })).to be_nil
    end
  end

  describe "#defaults" do
    it "allows you to set defaults" do
      subject.with do
        subject.defaults({ a: 1 })
        expect(subject.a).to eq(1)
      end
    end

    it "allows you to override defaults" do
      subject.with({ a: 2 }) do
        subject.defaults({ a: 1 })
        expect(subject.a).to eq(2)
      end
    end
  end

  describe "#cache_key" do
    it "allows you to generate cache key" do
      keys = {}
      subject.with({ a: 1 }) do
        keys[1] = subject.cache_key
        subject.with({ b: 1 }) do
          keys[2] = subject.cache_key
        end
        keys[3] = subject.cache_key
        expect(keys[1]).not_to eq(keys[2])
        expect(keys[1]).to eq(keys[3])
      end
    end
  end

  describe "#method_missing" do
    it "allows you to set data at any point" do
      subject.with do
        subject.a = 1
        expect(subject.a).to eq(1)
      end
    end


    it "delegates some methods to the hash" do
      subject.with({ a: 1 }) do
        expect(subject.keys).to eq([:a])
      end
    end
  end
end
