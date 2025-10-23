module SimplifiedTopModule(x, y, z);
    input x, y;
    output z;
    
    // Directly implement the logic for the top-level module
    // without needing separate A and B modules
    assign z = ((x & (x ^ y)) | (x == y)) ^ ((x & (x ^ y)) & (x == y));
endmodule