module fixed_point_adder #(
    parameter N = 16  // Total bits
) (
    input wire [N-1:0] a,
    input wire [N-1:0] b,
    output wire [N-1:0] c
);

    // Simple unsigned addition works correctly for 2's complement numbers
    assign c = a + b;

endmodule