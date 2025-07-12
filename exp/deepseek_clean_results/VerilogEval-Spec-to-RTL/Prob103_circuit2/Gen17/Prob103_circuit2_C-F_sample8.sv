module TopModule (
    input a,
    input b,
    input c,
    input d,
    output q
);
    // Optimal 4-input even parity check
    assign q = ~(a ^ b ^ c ^ d);
endmodule