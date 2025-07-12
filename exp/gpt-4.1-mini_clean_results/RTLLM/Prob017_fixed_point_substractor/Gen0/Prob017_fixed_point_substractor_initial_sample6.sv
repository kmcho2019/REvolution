module fixed_point_subtractor #(
    parameter integer Q = 8,          // Number of fractional bits
    parameter integer N = 16          // Total number of bits (integer + fractional + sign)
)(
    input  wire [N-1:0] a,            // First fixed-point operand
    input  wire [N-1:0] b,            // Second fixed-point operand
    output reg  [N-1:0] c             // Result of subtraction
);

    // Internal registers
    reg signed [N-1:0] a_signed;
    reg signed [N-1:0] b_signed;
    reg signed [N-1:0] res;
    reg signed [N-1:0] abs_a;
    reg signed [N-1:0] abs_b;

    // Helper wires for sign bits
    wire sign_a = a[N-1];
    wire sign_b = b[N-1];

    // Compute absolute value function inline
    function signed [N-1:0] abs_val(input signed [N-1:0] val);
        begin
            abs_val = (val < 0) ? -val : val;
        end
    endfunction

    always @(*) begin
        a_signed = $signed(a);
        b_signed = $signed(b);

        if (sign_a == sign_b) begin
            // Same sign subtraction: a - b
            res = a_signed - b_signed;
            // Result sign is same as inputs (inherent in subtraction)
        end else begin
            // Different signs: add magnitudes
            abs_a = abs_val(a_signed);
            abs_b = abs_val(b_signed);

            if (sign_a == 0 && sign_b == 1) begin
                // a positive, b negative: a - (-b) = a + |b|
                // Compare a and |b| magnitude for sign decision:
                // Actually a > 0 and b < 0, so res = a + |b|
                res = abs_a + abs_b;
                // sign positive if |a| > |b| (a and b have different signs, but since a is positive, res is positive)
                // but addition result is always positive because both are positive in magnitude, so sign = 0
            end else if (sign_a == 1 && sign_b == 0) begin
                // a negative, b positive: (-a) - b = -(|a| + b)
                res = -(abs_a + abs_b);
                // sign negative
            end else begin
                // Defensive default, should never occur
                res = a_signed - b_signed;
            end
        end

        // Handle zero result: set sign bit to 0 explicitly
        if (res == 0) begin
            res[N-1] = 1'b0;
        end

        c = res[N-1:0];
    end

endmodule