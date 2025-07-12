module fixed_point_subtractor #(
    parameter Q = 8,          // Fractional bits
    parameter N = 16          // Total bits (integer + fractional)
)(
    input  wire signed [N-1:0] a,
    input  wire signed [N-1:0] b,
    output wire signed [N-1:0] c
);

    wire signed [N-1:0] diff = a - b;
    wire zero = (diff == 0);

    assign c = zero ? {N{1'b0}} : diff;

endmodule