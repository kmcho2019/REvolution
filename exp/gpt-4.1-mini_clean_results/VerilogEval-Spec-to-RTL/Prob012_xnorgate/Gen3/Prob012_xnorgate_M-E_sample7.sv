module TopModule (
    input a,
    input b,
    output out
);

wire xor_out;

xor (xor_out, a, b);
not (out, xor_out);

endmodule