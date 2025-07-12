module TopModule (
    input a,
    input b,
    input c,
    input d,
    output q
);

    // Direct implementation of even parity check
    assign q = ~(a ^ b ^ c ^ d);

endmodule