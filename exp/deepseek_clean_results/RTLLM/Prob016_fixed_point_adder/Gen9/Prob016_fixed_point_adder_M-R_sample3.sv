module fixed_point_adder #(
    parameter Q = 8,  // Fractional bits
    parameter N = 16   // Total bits
) (
    input wire [N-1:0] a,
    input wire [N-1:0] b,
    output wire [N-1:0] c
);

    // Treat inputs as signed values
    wire signed [N-1:0] a_signed = a;
    wire signed [N-1:0] b_signed = b;
    
    // Direct signed addition
    wire signed [N-1:0] sum = a_signed + b_signed;
    
    // The signed addition automatically handles:
    // - Same sign addition
    // - Different sign subtraction
    // - Proper sign handling
    // - Two's complement arithmetic
    
    assign c = sum[N-1:0];

    // Overflow detection (optional)
    // wire overflow = (a_signed[N-1] == b_signed[N-1]) && 
    //                (sum[N-1] != a_signed[N-1]);
    
endmodule