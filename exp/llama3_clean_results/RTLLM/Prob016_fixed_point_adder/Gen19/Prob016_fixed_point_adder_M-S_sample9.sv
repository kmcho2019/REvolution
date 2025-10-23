module fixed_point_adder #(
    parameter Q = 8, // Number of fractional bits
    parameter N = 16 // Total number of bits
)(
    input signed [N-1:0] a,
    input signed [N-1:0] b,
    output signed [N-1:0] c
);

    // Calculate the sum of a and b, handling overflow
    assign c = (a + b) > { {N-1{1'b1}}, {1'b0} }? 
               { {N-1{1'b1}}, {1'b0} } : 
               (a + b) < { {N-1{1'b0}}, {1'b1} }? 
               { {N-1{1'b0}}, {1'b1} } : 
               a + b;

endmodule