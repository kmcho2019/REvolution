module NovelModule(x, y, z);
    input x, y;
    output z;
    
    // Direct implementation of the logic based on x and y
    assign z = (x & ~y) | (~x & y) | (x & y & (x ^ y));
endmodule