require File.dirname(__FILE__) + '/../test_helper'
require 'public_controller'

class PublicControllerTest < ActionController::IntegrationTest 
  fixtures :all
  
  def test_index
    get "/public"
    assert_response 302
  end

  def test_basic_read_tests
    get "/public/source/home:Iggy"
    assert_response :success
    get "/public/source/home:Iggy/_meta"
    assert_response :success
    get "/public/source/home:Iggy/_config"
    assert_response :success
    get "/public/source/home:Iggy/TestPack"
    assert_response :success
    get "/public/source/home:Iggy/TestPack/_meta"
    assert_response :success

    get "/public/source"
    assert_response 403
    get "/public/source/DoesNotExist/_meta"
    assert_response 404
    get "/public/source/home:Iggy/DoesNotExist/_meta"
    assert_response 404

    get "/public/build/home:Iggy/10.2/i586/TestPack"
    assert_response :success

    # hidden project access
    get "/public/source/HiddenProject"
    assert_response 404
    get "/public/source/HiddenProject/_config"
    assert_response 404
    get "/public/source/HiddenProject/_meta"
    assert_response 404
    get "/public/source/HiddenProject/pack"
    assert_response 404
    get "/public/source/HiddenProject/pack/_meta"
    assert_response 404

  end

  def test_lastevents
    # old route
    get "/lastevents"
    assert_response :success
    # new route
    get "/public/lastevents"
    assert_response :success
  end

  def test_distributions
    get "/public/distributions"
    assert_response :success
  end

  def test_get_files
    get "/public/source/home:Iggy/TestPack/myfile"
    assert_response 200
    assert_match "DummyContent", @response.body

    get "/public/source/home:Iggy/TestPack/myfile2"
    assert_response 404
    assert_match(/myfile2: no such file/, @response.body)

    get "/public/build/home:Iggy/10.2/i586/TestPack/doesnotexist"
    assert_response 404
    # FIXME: do a working getbinary call
  end

  def test_binaries
    get "/public/binary_packages/home:Iggy/TestPack"
    assert_response :success
    # without binaries, there is little to test here
    assert_tag :tag => 'package'
  end
end
