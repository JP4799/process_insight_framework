# GitHub Repository: Process Insight Toolbox


## Table of Contents

- `selection_menu.m`: This script displays a menu for gathering user input, facilitating the selection process.
- `read_directory.m`: A script to read a directory, gather image file paths, and store them in a cell array.
- `read_images.m`: Load images from file paths into memory.
- `process_images.m`: Convert loaded images into matrices suitable for t-SNE (t-Distributed Stochastic Neighbor Embedding).
- `tsne_calc_v2.m`: Calculate t-SNE to reduce the dimensionality of image data while preserving relationships.
- `tsne_show.m`: Visualize the t-SNE results in a plot.
- `save_data.m`: Save processed data into CSV and MATLAB (.mat) formats.
- `backtrans_dbscan.m`: Set up parameters for the DBSCAN (Density-Based Spatial Clustering of Applications with Noise) algorithm after t-SNE back-transformation.
- `export_images.m`: Export images from the results of DBSCAN clustering.
- `gui_tsne.m`: Graphical user interface (GUI) for the image processing framework using t-SNE.
- `import_data.m`: Functionality to import data into the toolbox.
- `parameter_exploration.m`: Perform parallel parameter exploration to optimize processing parameters.
- `set_dbscan.m`: Define settings for the DBSCAN algorithm.
- `show_image.m`: Display images using this function.
- `status_logging.m`: Logging function to keep track of the processing pipeline.
- `tsne_settings.m`: GUI to adjust settings for t-SNE.
