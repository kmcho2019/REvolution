module fixed_point_subtractor #(
    parameter Q = 16,  // Fractional bits
    parameter N = 32    // Total bits
) (
    input wire signed [N-1:0] a,
    input wire signed [N-1:0] b,
    output wire signed [N-1:0] c,
    output wire zero       // Zero result flag
);

    // Direct subtraction
    assign c = a - b;
    
    // Zero detection
    assign zero = (c == 0);

endmodule