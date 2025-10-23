module TopModule(
    input  [7:0] a,  // 8-bit 2's complement input number
    input  [7:0] b,  // 8-bit 2's complement input number
    output [7:0] s,  // 8-bit result of the addition
    output      overflow  // indicator of signed overflow
);

    // Directly add the two numbers and detect overflow
    assign s = a + b;
    assign overflow = (a[7] == b[7]) && (a[7] != s[7]);

endmodule