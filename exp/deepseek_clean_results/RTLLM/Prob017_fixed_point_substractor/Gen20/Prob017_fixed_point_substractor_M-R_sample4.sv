module fixed_point_subtractor #(
    parameter N = 32,
    parameter Q = 16
) (
    input wire [N-1:0] a,
    input wire [N-1:0] b,
    output wire [N-1:0] c
);

    // Internal subtraction result
    wire [N-1:0] sub_value = a - b;

    // Zero detection (all bits zero)
    wire zero_flag = ~(|sub_value);

    // Output assignment with explicit zero handling
    assign c = zero_flag ? {N{1'b0}} : sub_value;

endmodule