module fixed_point_adder #(
    parameter integer Q = 8,           // Number of fractional bits
    parameter integer N = 16           // Total number of bits including sign and fraction
)(
    input  wire signed [N-1:0] a,      // First fixed-point operand (two's complement)
    input  wire signed [N-1:0] b,      // Second fixed-point operand (two's complement)
    output reg  signed [N-1:0] c       // Fixed-point addition result
);

    always @(*) begin
        // Direct signed addition handles both addition and subtraction correctly
        c = a + b;
    end

endmodule