module TopModule(x, y, z);
    input x, y;
    output z;
    
    // Simplified combination logic
    assign z = (x & ~y) | (~x & y) | (x & y);
endmodule