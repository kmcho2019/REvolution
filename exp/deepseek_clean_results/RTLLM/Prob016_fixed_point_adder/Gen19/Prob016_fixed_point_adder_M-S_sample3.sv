module fixed_point_adder #(
    parameter Q = 8,  // Fractional bits (kept for interface)
    parameter N = 16  // Total bits
) (
    input wire signed [N-1:0] a,
    input wire signed [N-1:0] b,
    output wire signed [N-1:0] c
);

    // Simple signed fixed-point addition
    // Verilog handles sign bits and overflow automatically
    assign c = a + b;

endmodule