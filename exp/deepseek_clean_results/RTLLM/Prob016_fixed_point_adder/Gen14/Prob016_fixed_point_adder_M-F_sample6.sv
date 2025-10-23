module fixed_point_adder #(
    parameter Q = 8,  // Number of fractional bits (default)
    parameter N = 16  // Total number of bits (default)
) (
    input wire [N-1:0] a,
    input wire [N-1:0] b,
    output wire [N-1:0] c
);

    // Treat inputs as signed for arithmetic
    wire signed [N-1:0] a_signed = a;
    wire signed [N-1:0] b_signed = b;
    
    // Perform signed addition
    wire signed [N-1:0] sum = a_signed + b_signed;
    
    // Define max and min representable values
    wire signed [N-1:0] max_val =  {1'b0, {(N-1){1'b1}}};
    wire signed [N-1:0] min_val = {1'b1, {(N-1){1'b0}}};
    
    // Detect overflow by comparing against limits
    wire overflow_pos = (sum > max_val);
    wire overflow_neg = (sum < min_val);
    
    // Implement arithmetic saturation
    assign c = overflow_pos ? max_val :
               overflow_neg ? min_val :
               sum;

endmodule