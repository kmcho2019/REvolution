module TopModule (
    input   [7:0] a,       // 8-bit input a
    input   [7:0] b,       // 8-bit input b
    output  [7:0] s,       // 8-bit output s
    output          overflow  // overflow flag
);

    assign s = a + b;  // Perform 8-bit addition
    assign overflow = (a[7] == b[7]) && (a[7] != s[7]);  // Check for signed overflow

endmodule