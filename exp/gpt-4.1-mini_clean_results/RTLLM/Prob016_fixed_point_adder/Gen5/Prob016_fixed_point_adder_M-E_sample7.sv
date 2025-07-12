module fixed_point_adder #(
    parameter integer Q = 8,    // Number of fractional bits
    parameter integer N = 16    // Total number of bits (including sign)
)(
    input  wire [N-1:0] a,
    input  wire [N-1:0] b,
    output reg  [N-1:0] c
);

    // Internal signals
    wire a_sign;
    wire b_sign;

    reg [N-1:0] a_abs;
    reg [N-1:0] b_abs;

    reg [N:0] sum_abs;   // One bit wider for addition overflow
    reg [N-1:0] diff_abs;

    reg res_sign;
    reg [N-1:0] res_abs;

    // Function to compute absolute value for two's complement input
    function [N-1:0] abs_val(input [N-1:0] val);
        begin
            if (val[N-1] == 1'b1) begin
                abs_val = (~val) + 1'b1;
            end else begin
                abs_val = val;
            end
        end
    endfunction

    // Function to compare absolute values: returns 1 if a >= b else 0
    function cmp_abs_ge(input [N-1:0] a_val, input [N-1:0] b_val);
        integer i;
        begin
            // Compare bits from MSB-1 down to LSB (excluding sign)
            cmp_abs_ge = 1'b1; // Default assume equal or greater
            for (i = N-1; i >= 0; i = i - 1) begin
                if (a_val[i] > b_val[i]) begin
                    cmp_abs_ge = 1'b1;
                    disable cmp_abs_ge_loop;
                end else if (a_val[i] < b_val[i]) begin
                    cmp_abs_ge = 1'b0;
                    disable cmp_abs_ge_loop;
                end
            end
            cmp_abs_ge_loop: ;
        end
    endfunction

    always @* begin
        a_sign = a[N-1];
        b_sign = b[N-1];

        a_abs = abs_val(a);
        b_abs = abs_val(b);

        if (a_sign == b_sign) begin
            // Same sign: sum absolute values, sign is a_sign
            sum_abs = a_abs + b_abs;

            // Handle overflow by saturating the result
            // If sum_abs exceeds max positive value (2^(N-1)-1), saturate
            if (sum_abs[N-1] == 1'b1) begin
                // Overflow, saturate to max positive or negative depending on sign
                if (a_sign == 1'b0) begin
                    // Positive overflow saturate to max positive: 0_111...111
                    res_abs = {1'b0, {(N-1){1'b1}}};
                end else begin
                    // Negative overflow saturate to max negative: 1_000...000
                    res_abs = {1'b1, {(N-1){1'b0}}};
                end
            end else begin
                // No overflow, assign sum_abs truncated to N bits
                res_abs = sum_abs[N-1:0];
            end
            res_sign = a_sign;
        end else begin
            // Different signs: subtract smaller absolute from larger absolute

            if (cmp_abs_ge(a_abs, b_abs)) begin
                // a_abs >= b_abs
                diff_abs = a_abs - b_abs;
                res_sign = a_sign; // Sign of operand with larger abs
            end else begin
                diff_abs = b_abs - a_abs;
                res_sign = b_sign;
            end

            // If result is zero, sign is 0 (positive)
            if (diff_abs == 0) begin
                res_sign = 1'b0;
            end

            res_abs = diff_abs;
        end

        // Construct final result with sign bit
        c = {res_sign, res_abs[N-2:0]};
    end

endmodule