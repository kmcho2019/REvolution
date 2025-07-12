module fixed_point_subtractor #(
    parameter Q = 16,    // Number of fractional bits
    parameter N = 32     // Total number of bits
) (
    input wire [N-1:0] a,
    input wire [N-1:0] b,
    output wire [N-1:0] c
);

    // Treat inputs as signed for arithmetic operations
    wire signed [N-1:0] a_signed = a;
    wire signed [N-1:0] b_signed = b;
    
    // Perform subtraction in two's complement
    wire signed [N-1:0] diff = a_signed - b_signed;
    
    // Detect zero result (all bits zero including sign)
    wire is_zero = diff == 0;
    
    // Assemble final output - force zero to positive representation
    assign c = is_zero ? {N{1'b0}} : diff;

endmodule