`timescale 1ns / 1ps

module fixed_point_subtractor #(
    parameter integer N = 16,   // Total bits (including sign)
    parameter integer Q = 8     // Fractional bits
)(
    input  wire [N-1:0] a,
    input  wire [N-1:0] b,
    output reg  [N-1:0] c
);

    // Local signals
    wire a_sign = a[N-1];
    wire b_sign = b[N-1];

    // Magnitude extraction: clear sign bit, treat as positive magnitude
    wire [N-2:0] a_mag = a[N-2:0];
    wire [N-2:0] b_mag = b[N-2:0];

    // Extended magnitude with leading zero to prevent overflow on add/sub
    wire [N-1:0] a_mag_ext = {1'b0, a_mag};
    wire [N-1:0] b_mag_ext = {1'b0, b_mag};

    reg [N-1:0] mag_res;  // magnitude result, up to N bits for carry
    reg        res_sign;  // result sign

    // Comparison of magnitudes for sign logic
    wire a_gt_b = (a_mag_ext > b_mag_ext);
    wire b_gt_a = (b_mag_ext > a_mag_ext);
    wire mag_eq  = (a_mag_ext == b_mag_ext);

    always @(*) begin
        if (a_sign == b_sign) begin
            // Same sign: subtract magnitudes
            if (a_gt_b) begin
                mag_res = a_mag_ext - b_mag_ext;
                res_sign = a_sign;
            end else if (b_gt_a) begin
                mag_res = b_mag_ext - a_mag_ext;
                res_sign = ~a_sign; // opposite sign because subtracting bigger from smaller
            end else begin
                // magnitudes equal, result zero
                mag_res = 0;
                res_sign = 1'b0; // sign zero for zero result
            end
        end else begin
            // Different signs: add magnitudes
            mag_res = a_mag_ext + b_mag_ext;
            // Result sign is a_sign if a's magnitude >= b's magnitude (since effectively a - (-b))
            // But adding magnitudes means signs differ, result is dominated by larger magnitude input.
            // Actually, when signs differ:
            // a - b = a + (-b) => if a positive and b negative, subtraction becomes addition
            // sign is a_sign because "subtracting a negative b" => addition with sign of a

            // The problem spec says:
            // "If a is positive and b is negative, add abs(a) + abs(b), result sign positive if a > b else negative"
            // This implies comparing magnitudes and determining sign accordingly.

            // Let's handle per spec:

            if (!a_sign && b_sign) begin
                // a positive, b negative
                // sign positive if a_mag >= b_mag else negative
                res_sign = a_gt_b || mag_eq ? 1'b0 : 1'b1;
            end else if (a_sign && !b_sign) begin
                // a negative, b positive
                // sign negative if b_mag >= a_mag else positive
                res_sign = b_gt_a || mag_eq ? 1'b1 : 1'b0;
            end else begin
                // Unexpected condition (should not occur)
                res_sign = 1'b0;
            end
        end

        // Handle zero result: force sign bit to 0
        if (mag_res == 0) begin
            res_sign = 1'b0;
        end

        // Assign output: sign bit + magnitude (lowest N-1 bits)
        c = {res_sign, mag_res[N-2:0]};
    end

endmodule