module fixed_point_adder #(
    parameter Q = 8,
    parameter N = 16
) (
    input wire [N-1:0] a,
    input wire [N-1:0] b,
    output wire [N-1:0] c
);

    // Treat inputs as signed for proper arithmetic
    wire signed [N-1:0] a_signed = a;
    wire signed [N-1:0] b_signed = b;
    
    // Perform signed addition (handles all sign combinations automatically)
    wire signed [N-1:0] sum = a_signed + b_signed;
    
    // Convert back to unsigned output
    assign c = sum[N-1:0];

endmodule