module TopModule (
    input a,
    input b,
    input c,
    input d,
    output q
);

    // XOR chain implementation of even parity checker
    assign q = ~(a ^ b ^ c ^ d);  // Inverts the XOR result to get even parity

endmodule