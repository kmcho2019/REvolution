module fixed_point_subtractor #(
    parameter Q = 16,  // Number of fractional bits
    parameter N = 32    // Total number of bits
) (
    input wire signed [N-1:0] a,
    input wire signed [N-1:0] b,
    output wire [N-1:0] c
);

    // Perform signed subtraction
    wire signed [N-1:0] sub_result = a - b;
    
    // Handle zero case (force positive zero)
    assign c = (sub_result[N-1:0] == 0) ? {1'b0, {N-1{1'b0}}} : sub_result[N-1:0];

endmodule