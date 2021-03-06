class Shoes
  @apps = []
  $urls = {}
  APPS = []

  def self.APPS; APPS end

  def self.app args={}, &blk
    args[:width] ||= 600
    args[:height] ||= 500
    args[:title] ||= 'green shoes'
    args[:left] ||= 0
    args[:top] ||= 0
    projector = args[:prjct] = args[:projector]
    args.delete :projector

    app = App.new args
    @apps.push app

    app.top_slot = Flow.new app.slot_attributes(app: app, left: 0, top: 0)

    win = get_win
    win.title = args[:title]
    win.set_default_size args[:width], args[:height]

    style = win.style
    style.set_bg Gtk::STATE_NORMAL, 65535, 65535, 65535

    class << app; self end.class_eval do
      define_method(:width){win.size[0]}
      define_method(:height){win.size[1]}
    end

    win.set_events Gdk::Event::BUTTON_PRESS_MASK | Gdk::Event::BUTTON_RELEASE_MASK | Gdk::Event::POINTER_MOTION_MASK

    win.signal_connect "delete-event" do
      app.animates.each &:stop
      false
    end

    win.signal_connect "destroy" do
      app.close
    end if @apps.size == 1

    win.signal_connect "button_press_event" do |w, e|
      app.mouse_button = e.button
      app.mouse_pos = app.win.pointer
      mouse_click_control app
      mouse_link_control app
    end
    
    win.signal_connect "button_release_event" do
      app.mouse_button = 0
      app.mouse_pos = app.win.pointer
      mouse_release_control app
    end

    win.signal_connect "motion_notify_event" do
      app.mouse_pos = app.win.pointer
      mouse_motion_control app
      mouse_hover_control app
      mouse_leave_control app
    end

    app.canvas = projector ? Gtk::DrawingArea.new : Gtk::Layout.new
    swin = Gtk::ScrolledWindow.new
    swin.set_policy Gtk::POLICY_NEVER, Gtk::POLICY_AUTOMATIC 
    swin.vadjustment.step_increment = 10  
    swin.add app.canvas
    win.add swin
    app.canvas.style = style
    app.win, app.swin = win, swin

    if blk
      app.instance_eval &blk
    elsif projector
      app.send :projector, projector
    else
      app.instance_eval{$urls[/^#{'/'}$/].call app}
    end

    Gtk.timeout_add 100 do
      unless app.win.destroyed?
        download_images_control app
        if size_allocated? app
          call_back_procs app
          app.width_pre, app.height_pre = app.width, app.height
        end
        show_hide_control app
        set_cursor_type app
      end
      true
    end

    call_back_procs app
    
    win.show_all
    @apps.pop
    Gtk.main if @apps.empty?
    app
  end
end
