module TopModule (
    input a,
    input b,
    input c,
    input d,
    output q
);

    assign q = ~(a ^ b ^ c ^ d);  // Single XNOR operation for even parity check

endmodule