% Reducing the number of gray levels in an image

function image = escala_grises(image,num_levels)
scaling_factor = 255 / (num_levels);
 for i = 1:1:num_levels
    ll=scaling_factor*(i-1);
    ul=ll+scaling_factor;
    mp= (ll+ul)/2;
    lc=image>=ll;
    if i ~=num_levels
        up=image<ul;
    else
        up=image<=ul;
    end
    index=lc & up;
    image(index)=mp;
 end
colormap("gray");
imagesc(image);
end



