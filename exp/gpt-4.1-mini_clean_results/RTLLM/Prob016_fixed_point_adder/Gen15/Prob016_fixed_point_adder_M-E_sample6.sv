module fixed_point_adder #(
    parameter integer N = 16,       // Total bits including sign
    parameter integer Q = 8         // Fractional bits
)(
    input  wire [N-1:0] a,          // Fixed-point input operand a (two's complement)
    input  wire [N-1:0] b,          // Fixed-point input operand b (two's complement)
    output reg  [N-1:0] c           // Fixed-point output result
);

    // Internal signed registers for operands and result
    reg signed [N-1:0] a_signed;
    reg signed [N-1:0] b_signed;
    reg signed [N:0]   res;       // One bit wider to capture overflow if needed

    always @(*) begin
        // Interpret inputs as signed fixed-point numbers
        a_signed = a;
        b_signed = b;

        // Perform signed addition
        res = a_signed + b_signed;

        // Assign result truncated to N bits (drop overflow bit if any)
        c = res[N-1:0];
    end

endmodule