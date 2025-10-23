module fixed_point_subtractor #(
    parameter Q = 16,    // Number of fractional bits
    parameter N = 32     // Total number of bits
) (
    input wire [N-1:0] a,
    input wire [N-1:0] b,
    output wire [N-1:0] c,
    output wire overflow
);

    // Treat inputs as signed for arithmetic operations
    wire signed [N-1:0] a_signed = a;
    wire signed [N-1:0] b_signed = b;
    
    // Perform subtraction
    wire signed [N-1:0] diff = a_signed - b_signed;
    
    // Simple overflow detection
    assign overflow = (a_signed[N-1] == b_signed[N-1]) && 
                     (diff[N-1] != a_signed[N-1]);
    
    // Direct output
    assign c = diff;

endmodule