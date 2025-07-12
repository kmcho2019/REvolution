module fixed_point_subtractor #(
    parameter Q = 8,          // Number of fractional bits
    parameter N = 16          // Total number of bits (integer + fractional)
)(
    input  wire signed [N-1:0] a,
    input  wire signed [N-1:0] b,
    output wire signed [N-1:0] c
);

    wire signed [N-1:0] diff = a - b;
    assign c = (diff == 0) ? {N{1'b0}} : diff;

endmodule