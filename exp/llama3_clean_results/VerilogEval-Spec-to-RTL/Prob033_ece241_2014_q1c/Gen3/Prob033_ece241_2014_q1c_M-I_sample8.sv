module TopModule(
    input  [7:0] a,  // 8-bit 2's complement input number
    input  [7:0] b,  // 8-bit 2's complement input number
    output [7:0] s,  // 8-bit result of the addition
    output      overflow  // indicator of signed overflow
);

    // Perform the 8-bit addition of the two input numbers
    assign s = a + b;
    
    // Simplified overflow detection
    assign overflow = (a[7] == b[7] && s[7]!= a[7]);

endmodule