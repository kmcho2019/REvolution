module TopModule(
    input x,
    input y,
    output z
);
    wire xor_xy = x ^ y;
    assign z = x | ~xor_xy;
endmodule