module SimplifiedTopModule(x, y, z);
    input x, y;
    output z;
    
    // Directly implement the required logic
    assign z = ((x & ~y) | (x == y)) ^ ((x & ~y) & (x == y));
endmodule