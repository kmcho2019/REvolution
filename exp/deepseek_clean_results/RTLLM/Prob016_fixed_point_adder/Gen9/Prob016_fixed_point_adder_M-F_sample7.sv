module fixed_point_adder #(
    parameter Q = 8,  // Fractional bits (documentation only)
    parameter N = 16  // Total bits
) (
    input wire [N-1:0] a,
    input wire [N-1:0] b,
    output wire [N-1:0] c
);

    // Treat inputs as signed values
    wire signed [N-1:0] a_signed = a;
    wire signed [N-1:0] b_signed = b;
    
    // Perform signed addition
    wire signed [N-1:0] sum = a_signed + b_signed;
    
    // Direct assignment (signed arithmetic handles all cases)
    assign c = sum[N-1:0];

    // Optional overflow detection (commented out)
    // wire overflow = (a_signed[N-1] == b_signed[N-1]) && 
    //                (sum[N-1] != a_signed[N-1]);
    
endmodule