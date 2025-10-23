module multi_8bit(
    input [7:0] A,
    input [7:0] B,
    output [15:0] product
);

    // Binary tree of conditional adders
    wire [15:0] level3 [3:0];
    wire [15:0] level2 [1:0];
    wire [15:0] level1;

    // Leaf nodes (bit 0 to 3)
    conditional_adder leaf0 (
        .A({8'b0, A}),
        .sel(B[0]),
        .sum_in(16'b0),
        .sum_out(level3[0])
    );

    conditional_adder leaf1 (
        .A({7'b0, A, 1'b0}),
        .sel(B[1]),
        .sum_in(16'b0),
        .sum_out(level3[1])
    );

    conditional_adder leaf2 (
        .A({6'b0, A, 2'b0}),
        .sel(B[2]),
        .sum_in(16'b0),
        .sum_out(level3[2])
    );

    conditional_adder leaf3 (
        .A({5'b0, A, 3'b0}),
        .sel(B[3]),
        .sum_in(16'b0),
        .sum_out(level3[3])
    );

    // Intermediate nodes (combining level3 results)
    conditional_adder node0 (
        .A({4'b0, A, 4'b0}),
        .sel(B[4]),
        .sum_in(level3[0] + level3[1]),
        .sum_out(level2[0])
    );

    conditional_adder node1 (
        .A({3'b0, A, 5'b0}),
        .sel(B[5]),
        .sum_in(level3[2] + level3[3]),
        .sum_out(level2[1])
    );

    // Final node (combining level2 results)
    conditional_adder root (
        .A({2'b0, A, 6'b0}),
        .sel(B[6]),
        .sum_in(level2[0] + level2[1]),
        .sum_out(level1)
    );

    // Handle MSB separately for better timing
    assign product = B[7] ? ({1'b0, A, 7'b0} + level1) : level1;

endmodule

module conditional_adder(
    input [15:0] A,
    input sel,
    input [15:0] sum_in,
    output [15:0] sum_out
);
    wire [15:0] selected_A = sel ? A : 16'b0;
    assign sum_out = sum_in + selected_A;
endmodule