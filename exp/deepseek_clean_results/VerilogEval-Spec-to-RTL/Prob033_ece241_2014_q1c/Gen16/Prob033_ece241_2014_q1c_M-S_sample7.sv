module TopModule(
    input signed [7:0] a,
    input signed [7:0] b,
    output signed [7:0] s,
    output overflow
);
    assign s = a + b;
    // Signed overflow occurs if:
    // Adding two positives gives negative, or
    // Adding two negatives gives positive
    assign overflow = (~a[7] & ~b[7] & s[7]) | (a[7] & b[7] & ~s[7]);
endmodule