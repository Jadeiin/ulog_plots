# ULog 绘图工具

本项目包含用于读取、处理和绘制 PX4 ULog 文件（.ulg）的工具，主要提供了 MATLAB 脚本，用于可视化使用 PX4 飞控的无人机和其他飞行器的飞行数据。

## 仓库结构

```
ulog_plots/
├── 1.PlotJuggler/             # PlotJuggler 配置文件夹
│   └── plotjuggler_px4.xml   # PlotJuggler 预设布局文件
├── 2.MATLAB/                  # MATLAB 代码主文件夹
│   ├── plot_ulg.m            # 处理和绘制 ULog 数据的脚本
│   ├── magnify/              # 用于详细图表检查的放大工具
│   └── ulgReader/            # ULog 文件读取器实现
└── plots/                    # 生成图表的默认输出文件夹
```

## 功能特点

- 使用 MATLAB 读取和解析 PX4 ULog (.ulg) 文件
- 生成全面的图表，包括：
  - 位置（X、Y、Z 轴）
  - 姿态（滚转、俯仰、偏航）
  - 角速度
  - 线性速度
  - 加速度
  - 电机输出
  - ...
- 将所有图表保存到有组织的文件夹结构中
- 使用内置的放大工具进行详细图表检查
- 支持 PlotJuggler 进行快速可视化

## 安装

1. 克隆此仓库：
   ```
   git clone https://github.com/Jadeiin/ulog_plots.git
   ```
2. 打开 MATLAB 并导航到仓库文件夹

## 使用方法

### 基本使用方法

1. 将 ULog 文件（.ulg）放在工作目录中或指定文件路径
2. 在 MATLAB 中打开 `plot_ulg.m`
3. 在代码中更新文件名：
   ```matlab
   file = 'your_logfile.ulg'; % 替换为日志文件名
   ```
4. 运行脚本
5. 生成的图表将保存在 `ulg_plots` 文件夹中

### 高级使用方法

可以通过编辑 `plot_ulg.m` 文件来自定义图表：

- 通过修改 `figureWidth` 和 `figureHeight` 来更改图表尺寸
- 通过 `titleSize`、`labelSize` 和 `legendSize` 参数调整字体大小
- 通过注释相应部分来启用/禁用特定图表
- 使用已加载的数据结构添加新的图表类型

### 使用 PlotJuggler

PlotJuggler 是一款强大的数据可视化工具，适合实时和离线数据分析：

1. 从 [PlotJuggler 官网](https://github.com/facontidavide/PlotJuggler) 安装最新版本
2. 运行 PlotJuggler 并打开 ULog 文件
3. 使用 `File -> Load Layout` 加载本仓库中的预设布局文件
4. 使用提供的 `plotjuggler_px4.xml` 布局文件

提供的布局文件包含多个专用标签页，每个标签页针对飞行数据的不同方面进行可视化。这些预设布局可帮助快速理解飞行性能和诊断问题，也可以基于这些布局创建自己的自定义布局。

## 包含的工具

- ulgReader: 一个快速的 MATLAB PX4 ULog 文件读取器。
- Magnify: 一个为 MATLAB 图表添加放大镜功能的工具。

## 系统要求

- MATLAB（在 R2022a 上测试通过）
- PlotJuggler（用于快速可视化）
- PX4 ULog 文件（PX4 版本 1.14 及以上，由于其数据结构的变化，可能不兼容旧版本）

## 问题

### 已经有了很多现成的 ULog 绘图工具，为什么还要写这个？

首先，现有的本地工具大部分依赖外部库，且不支持最新的 ULog 格式，比如 `pyulog` 和 MATLAB 的 UAV 工具箱，前者需要安装 Python 和相关库，后者无法在旧版本的 MATLAB 上读取新的 ULog 格式。同时，现有的工具由于解析数据格式不统一（不向后兼容或自拟格式），大多是无法扩展的，本项目的设计采用基于 PX4 ULog 最新的日志结构，便于后续扩展和修改。

## 许可证

本项目使用 MIT 许可证，详见 [LICENSE](LICENSE) 文件。MIT 许可证是一种宽松的软件许可协议，它基本上允许任何人对软件进行任何处理，包括复制、修改、合并、发布、分发、再许可和/或销售软件副本，前提是软件的版权声明和许可声明包含在所有副本中。

本项目也包含使用其他许可证的第三方工具：
- ulgReader 在 GNU GPLv3 下分发
- Magnify 基于 MATLAB File Exchange 的代码

## 贡献

欢迎贡献！请随时提交 Pull Request 或为 bug 和功能请求创建 Issues。