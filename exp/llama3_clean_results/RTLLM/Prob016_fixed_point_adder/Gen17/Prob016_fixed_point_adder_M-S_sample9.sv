module fixed_point_adder #(
    parameter Q = 8, // Number of fractional bits
    parameter N = 16 // Total number of bits
)(
    input signed [N-1:0] a,
    input signed [N-1:0] b,
    output signed [N-1:0] c
);

    // Calculate the sum of a and b
    wire signed [N-1:0] sum = a + b;

    // Simplify overflow handling by directly checking the MSB
    assign c = (sum[N-1] == 1'b1 && sum == {N{1'b1}})? -1 : 
               (sum[N-1] == 1'b0 && sum == {1'b0, {N-1{1'b1}}})? {N{1'b1}} - 1 : 
               sum;

endmodule