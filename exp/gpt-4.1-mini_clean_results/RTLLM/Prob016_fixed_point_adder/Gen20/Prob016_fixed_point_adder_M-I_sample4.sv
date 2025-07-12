module fixed_point_adder #(
    parameter integer Q = 8,              // Number of fractional bits
    parameter integer N = 16              // Total bits including integer and fractional parts
)(
    input  wire signed [N-1:0] a,         // First fixed-point operand (signed two's complement)
    input  wire signed [N-1:0] b,         // Second fixed-point operand (signed two's complement)
    output reg  signed [N-1:0] c          // Result of fixed-point addition
);

    // Internal register to hold the addition result
    reg signed [N-1:0] res;

    always @(*) begin
        // Perform signed fixed-point addition directly
        res = a + b;
        c = res;
    end

endmodule