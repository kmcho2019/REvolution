module TopModule(
    input signed [7:0] a,
    input signed [7:0] b,
    output signed [7:0] s,
    output overflow
);
    // Simple addition using + operator
    assign s = a + b;
    
    // Overflow occurs when:
    // Two positives make negative or two negatives make positive
    assign overflow = (a[7] == b[7]) && (s[7] != a[7]);
endmodule