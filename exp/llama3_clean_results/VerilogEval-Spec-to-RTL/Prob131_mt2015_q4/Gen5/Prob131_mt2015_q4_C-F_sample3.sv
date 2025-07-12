module A(x, y, z);
    input x, y;
    output z;
    assign z = (x ^ y) & x;
endmodule

module B(x, y, z);
    input x, y;
    output z;
    assign z = (x == y);
endmodule

module TopModule(x, y, z);
    input x, y;
    output z;
    
    // Directly applying the logical operations
    assign z = ((x ^ y) & x | (x == y)) ^ (((x ^ y) & x) & (x == y));
endmodule