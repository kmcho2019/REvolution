module TopModule(x, y, z);
    input x, y;
    output z;

    assign z = ((x ^ y) & x) | ((x & y) | (!x &!y)); // Directly compute output z
endmodule