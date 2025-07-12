module fixed_point_adder #(
    parameter integer Q = 8,          // Number of fractional bits
    parameter integer N = 16          // Total bits including sign
)(
    input  wire [N-1:0] a,            // Fixed-point operand a (signed two's complement)
    input  wire [N-1:0] b,            // Fixed-point operand b (signed two's complement)
    output reg  [N-1:0] c             // Fixed-point result
);

    reg sign_a, sign_b, sign_res;
    reg [N-2:0] abs_a, abs_b, abs_res;

    // Calculate absolute value (magnitude) of input
    function [N-2:0] abs_val;
        input [N-1:0] val;
        begin
            if (val[N-1] == 1'b0)
                abs_val = val[N-2:0];
            else
                abs_val = (~val[N-2:0] + 1'b1);
        end
    endfunction

    always @* begin
        sign_a = a[N-1];
        sign_b = b[N-1];
        abs_a  = abs_val(a);
        abs_b  = abs_val(b);

        if (sign_a == sign_b) begin
            // Same sign: add magnitudes
            abs_res = abs_a + abs_b;
            sign_res = sign_a;
        end else begin
            // Different signs: subtract smaller from larger magnitude
            if (abs_a >= abs_b) begin
                abs_res = abs_a - abs_b;
                sign_res = sign_a;
            end else begin
                abs_res = abs_b - abs_a;
                sign_res = sign_b;
            end
        end

        c = {sign_res, abs_res};
    end

endmodule