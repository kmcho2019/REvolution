module TopModule (
    input a,
    input b,
    input c,
    input d,
    output q
);

    // Explicit even parity check with direct assignment
    assign q = ~(a ^ b ^ c ^ d);

endmodule