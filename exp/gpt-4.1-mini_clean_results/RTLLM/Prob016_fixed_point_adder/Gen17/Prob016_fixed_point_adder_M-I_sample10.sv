module fixed_point_adder #(
    parameter integer Q = 8,          // Number of fractional bits
    parameter integer N = 16          // Total number of bits including sign and fractional parts
)(
    input  wire [N-1:0] a,            // Fixed-point operand a (two's complement)
    input  wire [N-1:0] b,            // Fixed-point operand b (two's complement)
    output reg  [N-1:0] c             // Fixed-point addition result (two's complement)
);

    // Internal registers
    reg [N-1:0] abs_a;
    reg [N-1:0] abs_b;
    reg [N-1:0] res;
    reg sign_a;
    reg sign_b;
    reg sign_res;
    reg [N-1:0] sum_abs;
    reg [N-1:0] diff_abs;
    reg a_gt_b;

    // Function to compute absolute value of N-bit two's complement number
    function [N-1:0] abs_val;
        input [N-1:0] val;
        begin
            if (val[N-1] == 1'b0)        // positive
                abs_val = val;
            else                        // negative: two's complement negation
                abs_val = (~val) + 1'b1;
        end
    endfunction

    // Always block for combinational logic
    always @(*) begin
        sign_a = a[N-1];
        sign_b = b[N-1];

        abs_a = abs_val(a);
        abs_b = abs_val(b);

        if (sign_a == sign_b) begin
            // Same sign: add absolute values
            sum_abs = abs_a + abs_b;

            // Check overflow of sum_abs beyond N bits - since sum_abs is N bits, overflow can occur if carry out from MSB 
            // but sum_abs is N bits only - ignoring overflow here as fixed width limits
            
            sign_res = sign_a;             // result sign same as inputs'
            res = sum_abs;

            // Handle saturation if sum_abs overflowed - problem doesn't require explicit saturation, so ignored

            // Assign sign bit explicitly (in two's complement, sign bit is part of value)
            // If sum_abs overflows, it wraps around which is acceptable here
        end else begin
            // Different signs: subtract smaller absolute value from larger absolute value
            if (abs_a >= abs_b) begin
                diff_abs = abs_a - abs_b;
                sign_res = sign_a;         // result sign same as operand with larger absolute value
            end else begin
                diff_abs = abs_b - abs_a;
                sign_res = sign_b;
            end

            // If difference is zero, sign_res should be 0 (positive zero)
            if (diff_abs == 0)
                sign_res = 1'b0;

            res = diff_abs;
        end

        // Compose final two's complement result from sign_res and magnitude res
        // If sign_res is 1 (negative), convert magnitude to two's complement negative number
        if (sign_res == 1'b0) begin
            // positive result
            c = res;
        end else begin
            // negative result: two's complement negate magnitude
            c = (~res) + 1'b1;
        end
    end

endmodule