module fixed_point_subtractor #(
    parameter Q = 16,  // Number of fractional bits
    parameter N = 32    // Total number of bits
) (
    input wire [N-1:0] a,
    input wire [N-1:0] b,
    output wire [N-1:0] c
);

    // Treat inputs as signed values
    wire signed [N-1:0] signed_a = a;
    wire signed [N-1:0] signed_b = b;
    
    // Perform signed subtraction
    wire signed [N-1:0] signed_res = signed_a - signed_b;
    
    // Detect zero result (check all bits including sign)
    wire is_zero = (signed_res == 0);
    
    // Force positive zero when result is zero
    assign c = is_zero ? {1'b0, {N-1{1'b0}}} : signed_res;

endmodule