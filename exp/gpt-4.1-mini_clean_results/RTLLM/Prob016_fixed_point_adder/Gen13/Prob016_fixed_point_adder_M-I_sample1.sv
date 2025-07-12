module fixed_point_adder #(
    parameter integer N = 16,       // Total bits: integer + fractional + sign
    parameter integer Q = 8         // Fractional bits precision (not used explicitly here)
)(
    input  wire signed [N-1:0] a,   // Signed fixed-point operand a
    input  wire signed [N-1:0] b,   // Signed fixed-point operand b
    output reg  signed [N-1:0] c    // Signed fixed-point result
);

    // Internal register to hold result
    reg signed [N-1:0] res;

    always @* begin
        // Add operands directly as signed numbers
        res = a + b;

        // Assign result
        c = res;
    end

endmodule