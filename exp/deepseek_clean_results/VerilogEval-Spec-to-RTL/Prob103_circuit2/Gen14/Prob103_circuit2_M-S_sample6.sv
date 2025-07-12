module TopModule (
    input a,
    input b,
    input c,
    input d,
    output q
);

    assign q = ~(a ^ b ^ c ^ d);  // XNOR of all inputs (even parity)

endmodule