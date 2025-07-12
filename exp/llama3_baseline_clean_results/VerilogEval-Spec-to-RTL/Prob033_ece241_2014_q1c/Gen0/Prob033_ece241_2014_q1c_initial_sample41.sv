module TopModule(
    input  [7:0] a,
    input  [7:0] b,
    output [7:0] s,
    output       overflow
);

    // Perform 9-bit addition to detect overflow
    assign {overflow, s} = a + b;

endmodule