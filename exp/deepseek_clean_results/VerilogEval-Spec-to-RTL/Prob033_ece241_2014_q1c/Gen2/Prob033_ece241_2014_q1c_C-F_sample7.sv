module TopModule(
    input [7:0] a,
    input [7:0] b,
    output [7:0] s,
    output overflow
);
    // Perform 8-bit addition and assign directly to output
    assign s = a + b;

    // Detect signed overflow:
    // 1. Positive + Positive = Negative (overflow)
    // 2. Negative + Negative = Positive (overflow)
    assign overflow = (~a[7] & ~b[7] & s[7]) |  // Case 1
                      (a[7] & b[7] & ~s[7]);   // Case 2
endmodule