require "spec_helper"
require "viewcoat/helper"

class FakeView
  include Viewcoat::Helper
end

describe FakeView do
  it "delegates to a cached store" do
    store = double
    allow(Viewcoat::Store).to receive(:new) { store }
    expect(store).to receive(:with).twice
    subject.coat.with
    subject.coat.with
  end
end
