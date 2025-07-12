module TopModule(x, y, z);
    input x, y;
    output z;

    // Directly compute the output 'z' based on the simplified logic
    assign z = ((x ^ y) & x) | ((x & y) | (!x & !y)) ^ (((x ^ y) & x) & ((x & y) | (!x & !y)));
endmodule