module TopModule(x, y, z);
    input x, y;
    output z;

    // Directly compute the output z based on the optimized logic
    assign z = (x & y) ^ ((x ^ y) & x);
endmodule