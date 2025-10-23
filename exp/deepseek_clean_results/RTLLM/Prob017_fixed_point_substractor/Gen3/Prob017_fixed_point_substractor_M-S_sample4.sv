module fixed_point_subtractor #(
    parameter N = 32    // Total number of bits
) (
    input wire signed [N-1:0] a,
    input wire signed [N-1:0] b,
    output wire signed [N-1:0] c
);

    assign c = a - b;

endmodule