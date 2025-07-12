module fixed_point_subtractor #(parameter Q = 8, parameter N = 16)(
    input  wire signed [N-1:0] a,
    input  wire signed [N-1:0] b,
    output wire signed [N-1:0] c
);

    // Intermediate signed subtraction result
    wire signed [N-1:0] diff = a - b;

    // Output with sign bit cleared if result is zero
    assign c = (diff == 0) ? {1'b0, diff[N-2:0]} : diff;

endmodule