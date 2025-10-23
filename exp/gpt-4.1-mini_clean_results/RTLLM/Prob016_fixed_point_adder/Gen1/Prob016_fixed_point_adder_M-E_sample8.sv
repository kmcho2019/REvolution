module fixed_point_adder #(
    parameter integer Q = 8,    // Number of fractional bits
    parameter integer N = 16    // Total number of bits (integer + fractional + sign)
)(
    input  wire [N-1:0] a,
    input  wire [N-1:0] b,
    output reg  [N-1:0] c
);

    // Internal registers for computation
    reg signed [N-1:0] a_signed;
    reg signed [N-1:0] b_signed;
    reg signed [N-1:0] res_signed;

    // Absolute values as unsigned
    reg [N-1:0] a_abs;
    reg [N-1:0] b_abs;

    // For comparison of absolute values
    reg a_abs_gte_b_abs;

    // Temporary variable for difference of absolute values
    reg [N-1:0] diff_abs;

    // Helper function: absolute value (two's complement)
    function [N-1:0] abs_val;
        input signed [N-1:0] val;
        begin
            if (val < 0)
                abs_val = -val;
            else
                abs_val = val;
        end
    endfunction

    always @(*) begin
        // Cast inputs to signed
        a_signed = $signed(a);
        b_signed = $signed(b);

        if (a_signed[N-1] == b_signed[N-1]) begin
            // Same sign: add directly
            res_signed = a_signed + b_signed;
        end else begin
            // Different signs: subtract absolute values
            a_abs = abs_val(a_signed);
            b_abs = abs_val(b_signed);

            a_abs_gte_b_abs = (a_abs >= b_abs);

            if (a_abs_gte_b_abs) begin
                diff_abs = a_abs - b_abs;
                // Result sign = sign of a
                if (diff_abs == 0) begin
                    res_signed = 0;
                end else if (a_signed < 0) begin
                    // negative result
                    res_signed = -$signed(diff_abs);
                end else begin
                    // positive result
                    res_signed = $signed(diff_abs);
                end
            end else begin
                diff_abs = b_abs - a_abs;
                // Result sign = sign of b
                if (diff_abs == 0) begin
                    res_signed = 0;
                end else if (b_signed < 0) begin
                    res_signed = -$signed(diff_abs);
                end else begin
                    res_signed = $signed(diff_abs);
                end
            end
        end

        // Assign final result (truncate if overflow occurs naturally)
        c = res_signed[N-1:0];
    end

endmodule