module fixed_point_adder #(
    parameter integer Q = 8,    // Number of fractional bits
    parameter integer N = 16    // Total bits including sign
)(
    input  wire [N-1:0] a,      // Fixed-point input operand a
    input  wire [N-1:0] b,      // Fixed-point input operand b
    output reg  [N-1:0] c       // Fixed-point addition result
);

    // Signed versions of inputs for easier arithmetic
    wire signed [N-1:0] a_signed = a;
    wire signed [N-1:0] b_signed = b;

    // Extract sign bits
    wire a_sign = a[N-1];
    wire b_sign = b[N-1];

    // Absolute value function (simple inline)
    function [N-1:0] abs_val(input signed [N-1:0] val);
        begin
            abs_val = (val[N-1]) ? (~val + 1'b1) : val;
        end
    endfunction

    reg [N-1:0] a_abs;
    reg [N-1:0] b_abs;
    reg signed [N-1:0] result;

    always @(*) begin
        a_abs = abs_val(a_signed);
        b_abs = abs_val(b_signed);

        if (a_sign == b_sign) begin
            // Same sign: result = a + b
            result = a_signed + b_signed;
        end else begin
            // Different signs: subtract smaller abs from larger abs
            if (a_abs > b_abs) begin
                // result sign is sign of a
                result = (a_sign) ? - (a_abs - b_abs) : (a_abs - b_abs);
            end else if (b_abs > a_abs) begin
                // result sign is sign of b
                result = (b_sign) ? - (b_abs - a_abs) : (b_abs - a_abs);
            end else begin
                // Equal magnitude but opposite signs -> zero
                result = 0;
            end
        end
        c = result;
    end

endmodule