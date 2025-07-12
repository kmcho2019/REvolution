module fixed_point_adder #(
    parameter integer N = 16,   // Total bits including sign bit
    parameter integer Q = 8     // Fractional bits (precision)
)(
    input  wire signed [N-1:0] a, // Fixed-point input operand a (two's complement signed)
    input  wire signed [N-1:0] b, // Fixed-point input operand b (two's complement signed)
    output reg  signed [N-1:0] c  // Fixed-point output result
);

    always @(*) begin
        c = a + b; // Signed addition preserves fixed-point format
    end

endmodule