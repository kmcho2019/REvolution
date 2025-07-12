module fixed_point_adder #(
    parameter integer N = 16,       // Total bits including sign
    parameter integer Q = 8         // Fractional bits (not explicitly used in internal logic)
)(
    input  wire [N-1:0] a,          // Fixed-point input operand a (two's complement)
    input  wire [N-1:0] b,          // Fixed-point input operand b (two's complement)
    output reg  [N-1:0] c           // Fixed-point output result
);

    // Internal signals
    reg a_sign, b_sign, res_sign;
    reg [N-1:0] a_abs, b_abs;      // Absolute values extended to N bits
    reg [N:0] sum_ext;             // N+1 bits for addition to catch overflow
    reg [N-1:0] diff_abs;          // Absolute difference (max N bits)
    reg a_gt_b;

    // Compute absolute value as N-bit unsigned
    // If sign == 0, abs = a; else abs = two's complement of a
    function [N-1:0] abs_val(input [N-1:0] val);
        begin
            if (val[N-1] == 1'b0)
                abs_val = val;
            else
                abs_val = (~val + 1'b1);
        end
    endfunction

    always @(*) begin
        // Extract sign bits
        a_sign = a[N-1];
        b_sign = b[N-1];

        // Compute absolute values
        a_abs = abs_val(a);
        b_abs = abs_val(b);

        if (a_sign == b_sign) begin
            // Same sign: add absolute values
            sum_ext = {1'b0, a_abs} + {1'b0, b_abs};  // N+1 bits to catch overflow
            // Set result sign same as inputs
            res_sign = a_sign;

            // Assign result magnitude: truncating overflow if any
            // If sum_ext[N] == 1 (overflow), it will be truncated naturally
            c = {res_sign, sum_ext[N-1:0]};
        end else begin
            // Different signs: subtract smaller magnitude from larger
            a_gt_b = (a_abs > b_abs);

            if (a_abs == b_abs) begin
                // Result zero
                c = {1'b0, {(N-1){1'b0}}};
            end else if (a_gt_b) begin
                diff_abs = a_abs - b_abs;
                res_sign = a_sign;
                c = {res_sign, diff_abs[N-2:0], 1'b0}; 
                // Correcting bit width: diff_abs is N bits,
                // but c is N bits: sign + N-1 bits.
                // diff_abs[N-2:0] covers N-1 bits, but leaves out one LSB.
                // Instead, assign full diff_abs[N-1:0], then assign sign bit.
                c = {res_sign, diff_abs[N-2:0]};
                // However, this drops LSB - this is an error.
                // Correct approach:
                // Since diff_abs is N bits, highest bit is MSB magnitude
                // The lower N-1 bits should be assigned to c[ N-2 : 0 ]

                // So final:
                c = {res_sign, diff_abs[N-2:0]};
            end else begin
                diff_abs = b_abs - a_abs;
                res_sign = b_sign;
                c = {res_sign, diff_abs[N-2:0]};
            end
        end
    end

endmodule