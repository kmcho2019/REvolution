module TopModule (
    input a,
    input b,
    input c,
    input d,
    output q
);

    assign q = ~(a ^ b ^ c ^ d);  // Compact even parity implementation

endmodule