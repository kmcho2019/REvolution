module fixed_point_subtractor #(
    parameter integer N = 16, // Total bits (including sign)
    parameter integer Q = 8   // Fractional bits (for documentation)
)(
    input  signed [N-1:0] a,
    input  signed [N-1:0] b,
    output signed [N-1:0] c
);

    wire signed [N-1:0] diff = a - b;

    // If result is zero, force sign bit to zero; else output diff directly
    assign c = (diff == 0) ? {1'b0, {(N-1){1'b0}}} : diff;

endmodule