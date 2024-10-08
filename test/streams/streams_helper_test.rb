require "test_helper"

class TestChannel < ApplicationCable::Channel; end

class Turbo::StreamsHelperTest < ActionView::TestCase
  attr_accessor :formats

  test "with streamable" do
    assert_dom_equal \
      %(<turbo-cable-stream-source channel="Turbo::StreamsChannel" signed-stream-name="#{Turbo::StreamsChannel.signed_stream_name("messages")}"></turbo-cable-stream-source>),
      turbo_stream_from("messages")
  end

  test "with multiple streamables, some blank" do
    assert_dom_equal \
      %(<turbo-cable-stream-source channel="Turbo::StreamsChannel" signed-stream-name="#{Turbo::StreamsChannel.signed_stream_name(["channel", nil, "", "messages"])}"></turbo-cable-stream-source>),
      turbo_stream_from("channel", nil, "", "messages")
  end

  test "with invalid streamables" do
    assert_raises ArgumentError, "streamables can't be blank" do
      turbo_stream_from("")
    end

    assert_raises ArgumentError, "streamables can't be blank" do
      turbo_stream_from(nil)
    end

    assert_raises ArgumentError, "streamables can't be blank" do
      turbo_stream_from("", nil)
    end
  end

  test "with streamable and html attributes" do
    assert_dom_equal \
      %(<turbo-cable-stream-source channel="Turbo::StreamsChannel" signed-stream-name="#{Turbo::StreamsChannel.signed_stream_name("messages")}" data-stream-target="source"></turbo-cable-stream-source>),
      turbo_stream_from("messages", data: { stream_target: "source" })
  end

  test "with channel" do
    assert_dom_equal \
      %(<turbo-cable-stream-source channel="NonExistentChannel" signed-stream-name="#{Turbo::StreamsChannel.signed_stream_name("messages")}"></turbo-cable-stream-source>),
      turbo_stream_from("messages", channel: "NonExistentChannel")
  end

  test "with channel as a class name" do
    assert_dom_equal \
      %(<turbo-cable-stream-source channel="TestChannel" signed-stream-name="#{Turbo::StreamsChannel.signed_stream_name("messages")}"></turbo-cable-stream-source>),
      turbo_stream_from("messages", channel: TestChannel)
  end

  test "with channel and extra data" do
    assert_dom_equal \
      %(<turbo-cable-stream-source channel="NonExistentChannel" signed-stream-name="#{Turbo::StreamsChannel.signed_stream_name("messages")}" data-payload="1"></turbo-cable-stream-source>),
      turbo_stream_from("messages", channel: "NonExistentChannel", data: {payload: 1})
  end

  test "custom turbo_stream builder actions" do
    assert_dom_equal <<~HTML.strip, turbo_stream.highlight("an-id")
      <turbo-stream action="highlight" target="an-id"><template></template></turbo-stream>
    HTML
    assert_dom_equal <<~HTML.strip, turbo_stream.highlight_all(".a-selector")
      <turbo-stream action="highlight" targets=".a-selector"><template></template></turbo-stream>
    HTML
  end
end
