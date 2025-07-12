module TopModule(x, y, z);
    input x, y;
    output z;
    
    // Directly implement the combined logic of A and B within the top module
    assign z = ((x ^ y) & x) | (x == y);
endmodule