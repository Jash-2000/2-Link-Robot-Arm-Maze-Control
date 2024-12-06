function [path_pts] = HC(init_val, final_val, n)
    % Half Cosine Path Generator  
    path_pts = init_val + ( (final_val - init_val)*0.5*(1-cos(linspace(0,pi,n))) );
end