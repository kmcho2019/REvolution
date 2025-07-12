module TopModule (
    input  x,
    input  y,
    output z
);
    wire xor_xy;

    xor (xor_xy, x, y);
    and (z, xor_xy, x);
endmodule