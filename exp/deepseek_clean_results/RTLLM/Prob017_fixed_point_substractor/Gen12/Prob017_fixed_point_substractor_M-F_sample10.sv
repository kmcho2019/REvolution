module fixed_point_subtractor #(
    parameter Q = 16,    // Number of fractional bits
    parameter N = 32     // Total number of bits
) (
    input wire [N-1:0] a,
    input wire [N-1:0] b,
    output wire [N-1:0] c,
    output wire overflow // Optional overflow flag
);

    // Parameter validation using generate (fails during elaboration)
    generate
        if (Q >= N) begin
            ERROR_FractionalBitsMustBeLessThanTotalBits error();
        end
    endgenerate

    // Treat inputs as signed for arithmetic operations
    wire signed [N-1:0] a_signed = a;
    wire signed [N-1:0] b_signed = b;
    
    // Power optimization: check if inputs are equal
    wire inputs_equal = (a == b);
    
    // Main subtraction operation
    wire signed [N-1:0] diff = a_signed - b_signed;
    
    // Simplified overflow detection
    assign overflow = (a_signed[N-1] == b_signed[N-1]) && 
                     (diff[N-1] != a_signed[N-1]) &&
                     !inputs_equal;
    
    // Final output with zero handling
    assign c = inputs_equal ? {N{1'b0}} : diff;

endmodule