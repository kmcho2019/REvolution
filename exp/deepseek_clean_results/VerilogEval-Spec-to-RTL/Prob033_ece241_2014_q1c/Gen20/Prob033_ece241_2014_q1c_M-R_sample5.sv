module TopModule(
    input signed [7:0] a,
    input signed [7:0] b,
    output signed [7:0] s,
    output overflow
);
    // Sum computation using built-in adder
    assign s = a + b;
    
    // Overflow occurs when:
    // 1. Both inputs are positive and sum is negative, OR
    // 2. Both inputs are negative and sum is positive
    assign overflow = (~a[7] & ~b[7] & s[7]) |  // Case 1
                     (a[7] & b[7] & ~s[7]);    // Case 2
endmodule