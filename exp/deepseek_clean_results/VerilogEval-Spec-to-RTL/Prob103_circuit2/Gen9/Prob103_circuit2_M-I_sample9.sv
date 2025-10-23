module TopModule (
    input a,
    input b,
    input c,
    input d,
    output q
);
    // Direct even parity calculation without inversion
    assign q = (a ^ b ^ c ^ d);
endmodule