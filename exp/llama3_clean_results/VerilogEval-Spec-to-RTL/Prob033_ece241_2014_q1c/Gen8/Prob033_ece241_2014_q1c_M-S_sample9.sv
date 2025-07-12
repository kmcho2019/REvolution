module TopModule (
    input  [7:0] a,
    input  [7:0] b,
    output [7:0] s,
    output overflow
);

    // Perform 8-bit addition
    assign {overflow, s} = a + b;

endmodule