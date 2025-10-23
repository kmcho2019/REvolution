module fixed_point_adder #(
    parameter integer Q = 8,          // Number of fractional bits
    parameter integer N = 16          // Total bits including sign
)(
    input  wire signed [N-1:0] a,     // Signed fixed-point operand a
    input  wire signed [N-1:0] b,     // Signed fixed-point operand b
    output reg  signed [N-1:0] c      // Signed fixed-point result
);

    reg signed [N-1:0] res;

    always @* begin
        res = a + b;                 // Signed addition naturally handles signs and magnitude
        c = res;                    // Assign result
    end

endmodule