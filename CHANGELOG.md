# Changelog

All notable changes to the Conky-LuaNV project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.0.0] - 2025-06-05

### Added
- Independent scaling for upload and download speed graphs
  - New tracking variables `max_upload_speed` and `max_download_speed`
  - New enum `graph_type` to distinguish between graph types
  - Global variable `current_graph_type` to track the current graph being drawn
- Enhanced Lua script for network speed conversion to Kbps/Mbps
- CPU power monitoring scripts for Intel RAPL interface
- Improved documentation with detailed configuration examples
- Storage drive temperature script
- Top CPU and Memory application scripts

### Fixed
- Issue where network graphs would share the same scale, making one graph appear tiny when speeds differ significantly
- Memory management issues to prevent potential double free and use-after-free conditions
- Replaced incorrect graph->width references with graph->graph_width

### Changed
- Updated README with comprehensive documentation of features and scripts
- Reorganized configuration sections for better readability
- Extended GitHub workflows for better build testing

### Credits
- Original project: Conky by Brenden Matthews and contributors
- Independent network graph scaling by Jayhub-ai
- Documentation and build system improvements by Neo 