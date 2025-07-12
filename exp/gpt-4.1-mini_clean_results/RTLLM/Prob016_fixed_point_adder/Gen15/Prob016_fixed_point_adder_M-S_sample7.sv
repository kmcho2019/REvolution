module fixed_point_adder #(
    parameter integer Q = 8,        // Number of fractional bits
    parameter integer N = 16        // Total bit width (including sign)
)(
    input  wire signed [N-1:0] a,   // First fixed-point operand (signed)
    input  wire signed [N-1:0] b,   // Second fixed-point operand (signed)
    output reg  signed [N-1:0] c    // Result of fixed-point addition (signed)
);

    always @(*) begin
        c = a + b;  // Signed addition handles sign and overflow correctly
    end

endmodule