require "gifanime"
require "rack/file"
require "capybara/rspec"
 
Capybara.app = Rack::File.new(File.dirname(__FILE__))
 
describe "sample.html", type: :feature do
  before(:all) do
    @rec = ScreenRecorder.new("sample.gif")
  end

  after(:all) do
    @rec.generate!
  end

  it "shows en message and toggles by the button", js: true do
    visit '/sample.html'
    @rec.add(page)

    page.should have_css(".contents div", count: 1)
    page.should have_css ".en"

    click_button "Change"
    @rec.add(page)

    page.should have_css(".contents div", count: 1)
    page.should have_css ".ja"

    click_button "Change"
    @rec.add(page)

    page.should have_css(".contents div", count: 1)
    page.should have_css ".kr"

    click_button "Change"
    @rec.add(page)

    page.should have_css(".contents div", count: 1)
    page.should have_css ".km"

    click_button "Change"
    @rec.add(page)

    page.should have_css(".contents div", count: 1)
    page.should have_css ".en"
  end
end

class ScreenRecorder
  attr_accessor :gifanime, :tmpdir

  def initialize(output)
    @gifanime = Gifanime.new(output, delay: 40)
    @tmpdir = Dir.mktmpdir
  end

  def add(page)
    file = "#{tmpdir}/#{gifanime.frames.size}.gif"
    page.save_screenshot(file)
    gifanime.add(file)
  end

  def generate!
    gifanime.generate!
  end
end
