module TopModule(
    input [3:0] x,
    input [3:0] y,
    output [4:0] sum
);

    // Perform 4-bit addition with overflow capture
    assign sum = {1'b0, x} + {1'b0, y};

endmodule