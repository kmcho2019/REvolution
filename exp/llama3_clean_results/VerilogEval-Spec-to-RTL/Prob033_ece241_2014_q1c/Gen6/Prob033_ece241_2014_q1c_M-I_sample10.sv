module TopModule(
    input  [7:0] a,  // 8-bit 2's complement input number
    input  [7:0] b,  // 8-bit 2's complement input number
    output [7:0] s,  // 8-bit result of the addition
    output      overflow  // indicator of signed overflow
);

    // Perform the addition using a carry-lookahead adder
    assign s = a + b;

    // Detect signed overflow using a separate adder
    assign overflow = (a[7] == b[7] && a[7] != s[7]);

    // Alternatively, use a more explicit calculation for overflow
    // assign overflow = ((a[7] == 1 && b[7] == 1 && s[7] == 0) || (a[7] == 0 && b[7] == 0 && s[7] == 1));

endmodule