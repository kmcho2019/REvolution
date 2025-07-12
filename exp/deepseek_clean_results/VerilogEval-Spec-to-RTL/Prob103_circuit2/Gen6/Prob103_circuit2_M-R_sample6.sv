module TopModule (
    input a,
    input b,
    input c,
    input d,
    output q
);

    // XNOR-based even parity checker
    assign q = ~(a ^ b ^ c ^ d);

endmodule