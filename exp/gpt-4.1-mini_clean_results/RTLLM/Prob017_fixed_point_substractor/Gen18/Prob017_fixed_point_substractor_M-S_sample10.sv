module fixed_point_subtractor #(
    parameter integer N = 16,
    parameter integer Q = 8
)(
    input  wire signed [N-1:0] a,
    input  wire signed [N-1:0] b,
    output wire signed [N-1:0] c
);

    wire signed [N-1:0] diff = a - b;
    assign c = (diff == 0) ? {N{1'b0}} : diff;

endmodule