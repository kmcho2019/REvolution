module TopModule(
    input a,
    input b,
    output out
);

wire xor_out;

xor u_xor (xor_out, a, b);
not u_not (out, xor_out);

endmodule