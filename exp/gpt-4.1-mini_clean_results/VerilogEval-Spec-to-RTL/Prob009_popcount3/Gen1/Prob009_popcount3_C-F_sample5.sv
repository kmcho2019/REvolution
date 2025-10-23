module TopModule(
    input  [2:0] in,
    output [1:0] out
);

    // Intermediate wire to hold the population count sum for clarity
    wire [1:0] popcount_sum;

    assign popcount_sum = in[0] + in[1] + in[2];
    assign out = popcount_sum;

endmodule