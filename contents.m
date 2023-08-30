% Toolbox implementing t-sne functionality V1.0
% script overview
% (c) Johannes Picker
% ===========================================
% GUI
%       gui_tsne.m                                          main gui for working with the tsne toolbox
% ===========================================
% scripts
%       selection_menu.m                                    Menu for gathering user-input
%       read_directory.m                                    reading of directory and saving image-paths in cell
%       read_images.m                                       loading images into memory
%       process_images.m                                    converting images into matrix for tsne 
%       tsne_calc_v2.m                                      calculating tsne
%       tsne_show.m                                         showing tsne
%       save_data.m                                         saving data into csv and .mat
%       backtrans_dbscan.m                                  settings for DBSCAN
%       export_images.m                                     export from DBSCAN
%       gui_tsne.m                                          gui for framework
%       import_data.m                                       import function
%       parameter_exploration.m                             parallel parameter exploration
%       set_dbscan.m                                        settings for DBSCAN
%       show_image.m                                        function for showing images
%       status_logging.m                                    logging function
%       tsne_settings.m                                     gui for settings in tsne
%       viz_images.m                                        function to visualize 3d images
