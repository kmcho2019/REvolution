module fixed_point_adder #(
    parameter integer Q = 8,          // Number of fractional bits (precision)
    parameter integer N = 16          // Total bits including sign and fractional bits
)(
    input  wire [N-1:0] a,            // First fixed-point operand (two's complement)
    input  wire [N-1:0] b,            // Second fixed-point operand (two's complement)
    output reg  [N-1:0] c             // Fixed-point addition result (two's complement)
);

    // Internal register for the result
    reg [N-1:0] res;

    // Internal signals for sign bits
    wire a_sign = a[N-1];
    wire b_sign = b[N-1];

    // Function to compute two's complement (negation)
    function [N-1:0] twos_complement;
        input [N-1:0] val;
        begin
            twos_complement = ~val + 1'b1;
        end
    endfunction

    // Function to compute absolute value of two's complement number
    function [N-1:0] abs_val;
        input [N-1:0] val;
        begin
            abs_val = val[N-1] ? twos_complement(val) : val;
        end
    endfunction

    // Variables for absolute values
    reg [N-1:0] a_abs;
    reg [N-1:0] b_abs;
    reg [N-1:0] abs_sum;
    reg [N-1:0] abs_diff;

    always @* begin
        a_abs = abs_val(a);
        b_abs = abs_val(b);

        if (a_sign == b_sign) begin
            // Same sign: add absolute values, sign remains the same
            abs_sum = a_abs + b_abs;
            // Handle potential overflow by truncation to N bits (wrap-around)
            // Set res MSB to original sign
            res = {a_sign, abs_sum[N-2:0]};
        end else begin
            // Different signs: subtract smaller abs from larger abs
            if (a_abs >= b_abs) begin
                abs_diff = a_abs - b_abs;
                // Result sign is sign of 'a'
                // If difference zero, sign bit is 0 (positive zero)
                res = (abs_diff == 0) ? {1'b0, {(N-1){1'b0}}} : {a_sign, abs_diff[N-2:0]};
            end else begin
                abs_diff = b_abs - a_abs;
                // Result sign is sign of 'b'
                res = (abs_diff == 0) ? {1'b0, {(N-1){1'b0}}} : {b_sign, abs_diff[N-2:0]};
            end
        end
        c = res;
    end

endmodule