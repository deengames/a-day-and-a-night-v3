###
# Trigger Bar: adds a "trigger" bar and you press to attack at the right time
# Doing so causes certain effects (1.5x damage on attack, 0.5x damage on defend,
# apply status effect on attack, nullify status effect on defend).
#
# Requires Yanfly's Keyboard Input script.
# Only tested with Yanfly's battle engine (but that shouldn't matter).
# 
# Version: 1.0
# Author: ashes999 (ashes999@yahoo.com)
###

class Scene_Battle < Scene_Base
  
  # How long the bar is on-screen.
  TRIGGER_TIME_IN_SECONDS = 0.75
  
  ####### Do not change codez below unless you know what you are doing! #######
  
  alias :trigger_post_start :post_start
  def post_start
    trigger_post_start
    @bar = create_image('trigger_bar')
    @bar.x = (Graphics.width - @bar.width) / 2
    @bar.y = 100
    
    @hit_area = create_image('trigger_bar_hit_area')
    @hit_area.x = @bar.x + (@bar.width - @hit_area.width) * 2 / 3 # two-thirds of the way to the right
    @hit_area.y = @bar.y - (@hit_area.height - @bar.height) / 2
    @hit_area.z = @bar.z + 1
    
    @trigger = create_image('trigger_bar_trigger')
    @trigger.x = @bar.x
    @trigger.y = @bar.y - @trigger.height
    
    hide_bar
    
    @trigger_velocity = @bar.width / (60 * TRIGGER_TIME_IN_SECONDS)
  end  
  
  alias :trigger_execute_action :execute_action  
  def execute_action    
    attacker = @subject
    action = attacker.current_action
    @trigger.x = @bar.x
    if $game_party.members.include?(attacker) && !action.nil? && action.attack?      
      show_bar
      @trigger_moving = true
    end
    trigger_execute_action
  end
  
  alias :trigger_update_basic :update_basic
  def update_basic    
    if @trigger_moving == true
      @trigger.x += @trigger_velocity
      if Input.key_pressed?(:SPACE)
        # Visual feedback: hit or miss
        is_hit = @trigger.x >= @hit_area.x && @trigger.x + @trigger.width <= @hit_area.x + @hit_area.width
        Logger.log("Hit? #{is_hit}")
        # No more moving, kthxbye
        @trigger_moving = false
        hide_bar
      end
    end
    @trigger.opacity = 0 if @trigger.x >= @bar.x + @bar.width
    trigger_update_basic
  end
  
  alias :trigger_process_action_end :process_action_end
  def process_action_end
    @trigger_moving = false
    hide_bar
    trigger_process_action_end    
  end
  
  alias :trigger_terminate :terminate
  def terminate
    dispose_image(@bar)
    dispose_image(@hit_area)
    dispose_image(@trigger)
    trigger_terminate
  end
  
  private
  
  def create_image(filename)
    image = Sprite.new
    image.bitmap = Cache.picture(filename)
    return image
  end
  
  def dispose_image(image)
    image.bitmap.dispose
    image.dispose
  end
  
  def show_bar
    @bar.opacity = 255
    @hit_area.opacity = 255
    @trigger.opacity = 255
  end
  
  def hide_bar
    @bar.opacity = 0
    @hit_area.opacity = 0
    @trigger.opacity = 0
  end
end
