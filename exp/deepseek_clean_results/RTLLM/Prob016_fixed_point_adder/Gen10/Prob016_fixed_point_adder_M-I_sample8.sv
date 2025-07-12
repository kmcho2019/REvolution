module fixed_point_adder #(
    parameter Q = 8,  // Fractional bits (documentation)
    parameter N = 16  // Total bits (integer + fractional)
) (
    input wire [N-1:0] a,
    input wire [N-1:0] b,
    output wire [N-1:0] c
    // output wire overflow  // Optional overflow flag
);

    // Internal signed representation
    wire signed [N-1:0] a_signed = a;
    wire signed [N-1:0] b_signed = b;
    
    // Perform signed addition (automatically handles sign extension)
    wire signed [N-1:0] sum = a_signed + b_signed;
    
    // Assign result (truncate to N bits)
    assign c = sum[N-1:0];
    
    // Optional overflow detection (commented out by default)
    // assign overflow = (a_signed[N-1] == b_signed[N-1]) && 
    //                  (sum[N-1] != a_signed[N-1]);

endmodule