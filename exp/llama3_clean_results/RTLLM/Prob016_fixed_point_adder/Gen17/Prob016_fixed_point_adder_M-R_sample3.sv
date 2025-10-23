module fixed_point_adder #(
    parameter Q = 8, // Number of fractional bits
    parameter N = 16 // Total number of bits
)(
    input signed [N-1:0] a,
    input signed [N-1:0] b,
    output signed [N-1:0] c
);

    // Calculate the sum of a and b, leveraging Verilog's built-in handling of signed arithmetic
    assign c = $signed(a) + $signed(b);

endmodule