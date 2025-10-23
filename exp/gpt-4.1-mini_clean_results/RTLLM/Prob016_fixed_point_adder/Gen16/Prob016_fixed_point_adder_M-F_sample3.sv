module fixed_point_adder #(
    parameter integer N = 16,       // Total bits including sign bit
    parameter integer Q = 8         // Fractional bits (precision)
)(
    input  wire [N-1:0] a,          // Fixed-point input operand a (two's complement)
    input  wire [N-1:0] b,          // Fixed-point input operand b (two's complement)
    output reg  [N-1:0] c           // Fixed-point output result
);

    // Internal signals
    wire a_sign, b_sign;
    reg  res_sign;
    wire [N-2:0] a_mag, b_mag;       // Magnitude parts (absolute value without sign)
    reg  [N-1:0] sum_mag;            // Sum magnitude (N bits to hold possible carry)
    reg  [N-2:0] diff_mag;           // Difference magnitude (N-1 bits)
    reg  a_mag_gt_b_mag;             // Comparison flag

    // Function to compute magnitude (absolute value) from two's complement input
    function [N-2:0] abs_mag;
        input [N-1:0] val;
        reg   [N-2:0] magnitude;
        begin
            if (val[N-1] == 1'b0) begin
                // Positive number: magnitude is lower N-1 bits directly
                magnitude = val[N-2:0];
            end else begin
                // Negative number: magnitude is two's complement of lower N-1 bits
                magnitude = (~val[N-2:0]) + 1'b1;
            end
            abs_mag = magnitude;
        end
    endfunction

    assign a_sign = a[N-1];
    assign b_sign = b[N-1];
    assign a_mag  = abs_mag(a);
    assign b_mag  = abs_mag(b);

    always @(*) begin
        if (a_sign == b_sign) begin
            // Same sign: add magnitudes
            sum_mag = {1'b0, a_mag} + {1'b0, b_mag}; // N bits sum with carry
            res_sign = a_sign;
            // Output: sign bit + lower N-1 bits (truncating overflow if any)
            c = {res_sign, sum_mag[N-2:0]};
        end else begin
            // Different signs: subtract smaller magnitude from larger
            if (a_mag == b_mag) begin
                // Result is zero
                res_sign = 1'b0;
                c = {res_sign, {(N-1){1'b0}}};
            end else begin
                a_mag_gt_b_mag = (a_mag > b_mag);
                if (a_mag_gt_b_mag) begin
                    diff_mag = a_mag - b_mag;
                    res_sign = a_sign;
                    c = {res_sign, diff_mag};
                end else begin
                    diff_mag = b_mag - a_mag;
                    res_sign = b_sign;
                    c = {res_sign, diff_mag};
                end
            end
        end
    end

endmodule