API_ROOT = 'Scripts/vx-ace-api'
require 'Scripts/vx-ace-api/vx_ace_api'
require 'Scripts/achievements'
require 'Scripts/custom_save_system'
require 'Scripts/image_title_menu'
require 'Scripts/extensions/Event_Window'

DEFAULT_ACHIEVEMENTS = {
    :khalid_bin_walid => Achievement.new("Khalid bin Walid", "Survive ten battles", "Notes TBD"),
    :son_of_adam => Achievement.new("Son of Adam", "Commit your first sin", "Every son of Adam sins and the best are those who repent often")
}

AchievementManager.initialize(DEFAULT_ACHIEVEMENTS)