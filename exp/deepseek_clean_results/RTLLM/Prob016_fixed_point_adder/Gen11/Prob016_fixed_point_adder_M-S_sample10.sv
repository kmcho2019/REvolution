module fixed_point_adder #(
    parameter Q = 8,
    parameter N = 16
) (
    input wire [N-1:0] a,
    input wire [N-1:0] b,
    output wire [N-1:0] c
);

    // Simple addition with fixed-point precision
    assign c = a + b;

endmodule