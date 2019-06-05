function y = safeAcos(x)
    
    if x < -1
        x = -1;
    elseif x > 1
        x = 1;
    end
    
    y = acos(x);
    
end