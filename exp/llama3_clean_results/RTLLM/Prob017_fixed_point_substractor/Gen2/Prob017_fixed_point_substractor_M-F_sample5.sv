module fixed_point_subtractor #(
    parameter Q = 8,  // Number of fractional bits
    parameter N = 16  // Total number of bits
)(
    input signed [N-1:0] a,
    input signed [N-1:0] b,
    output signed [N-1:0] c
);

wire signed [N-1:0] abs_a = (a[N-1] == 1'b0)? a : -a;
wire signed [N-1:0] abs_b = (b[N-1] == 1'b0)? b : -b;

// Calculate the result based on the signs of a and b
wire signed [N-1:0] result_same_sign = a[N-1] == 1'b0 && b[N-1] == 1'b0? abs_a - abs_b : 
                                     a[N-1] == 1'b1 && b[N-1] == 1'b1? abs_a - abs_b : 
                                     a[N-1] == 1'b0 && b[N-1] == 1'b1? abs_a + abs_b : 
                                     a[N-1] == 1'b1 && b[N-1] == 1'b0? abs_a + abs_b;

assign c = result_same_sign;

endmodule