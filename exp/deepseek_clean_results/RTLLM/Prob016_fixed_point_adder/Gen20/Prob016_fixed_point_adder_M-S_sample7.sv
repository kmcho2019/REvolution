module fixed_point_adder #(
    parameter Q = 8,  // Fractional bits
    parameter N = 16  // Total bits
) (
    input wire signed [N-1:0] a,
    input wire signed [N-1:0] b,
    output wire [N-1:0] c
);

    // Perform signed addition
    wire signed [N:0] sum_ext = a + b;
    
    // Detect overflow (when result exceeds N-bit signed range)
    wire overflow = (sum_ext[N:N-1] == 2'b01) || (sum_ext[N:N-1] == 2'b10);
    
    // Saturated values
    wire [N-1:0] max_pos = {1'b0, {(N-1){1'b1}}};
    wire [N-1:0] max_neg = {1'b1, {(N-1){1'b0}}};
    
    // Result selection
    assign c = overflow ? (sum_ext[N] ? max_neg : max_pos) : sum_ext[N-1:0];

endmodule