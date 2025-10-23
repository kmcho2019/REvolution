module TopModule(
    input [7:0] a,
    input [7:0] b,
    output [7:0] s,
    output overflow
);

    // Perform 8-bit signed addition
    assign {overflow, s} = {1'b0, a} + {1'b0, b};

endmodule