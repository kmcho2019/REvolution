module TopModule (
    input  x,
    input  y,
    output z
);

wire xor_out;

xor u_xor (xor_out, x, y);
and u_and (z, xor_out, x);

endmodule