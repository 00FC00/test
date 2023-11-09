require 'xcodeproj'

# 定义工程文件路径
project_path = 'Game.xcodeproj'
target_name = 'Game'
resource_folder_path = 'Resources' # 这是包含所有 Bundle 的文件夹路径

# 打开工程文件
project = Xcodeproj::Project.open(project_path)

# 获取目标(Target)
target = project.targets.select { |t| t.name == target_name }.first

if target
  # 添加 Resource 文件夹中的所有 Bundle 到 "Copy Bundle Resources" 阶段
  build_phase = target.resources_build_phase

  Dir.glob(File.join(resource_folder_path, '*.bundle')).each do |bundle_path|
    bundle_name = File.basename(bundle_path)
    resource_bundle = project.new(Xcodeproj::Project::Object::PBXBuildFile)
    resource_bundle.file_ref = project.main_group.new_file(bundle_path)
    build_phase.files << resource_bundle

    puts "已将 #{bundle_name} 添加到 #{target_name} 的 Copy Bundle Resources 阶段。"
  end

  # 保存工程文件
  project.save
else
  puts "未找到名为 #{target_name} 的目标。"
end
