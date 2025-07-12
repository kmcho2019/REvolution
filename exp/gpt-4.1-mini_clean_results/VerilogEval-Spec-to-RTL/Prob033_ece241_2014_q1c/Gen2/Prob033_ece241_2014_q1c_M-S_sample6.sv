module TopModule (
    input  [7:0] a,
    input  [7:0] b,
    output [7:0] s,
    output       overflow
);

    // Direct addition to output
    assign s = a + b;

    // Overflow occurs if inputs have same sign and sum differs in sign
    assign overflow = (~(a[7] ^ b[7])) & (a[7] ^ s[7]);

endmodule