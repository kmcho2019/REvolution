module SimplifiedModule(x, y, z);
    input x, y;
    output z;

    assign z = ((x ^ y) & x) | (x === y);
endmodule