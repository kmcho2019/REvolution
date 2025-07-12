module fixed_point_subtractor #(
    parameter Q = 8,            // Number of fractional bits (default)
    parameter N = 16            // Total bits (integer + fractional) (default)
)(
    input  wire [N-1:0] a,     // First fixed-point operand
    input  wire [N-1:0] b,     // Second fixed-point operand
    output reg  [N-1:0] c      // Result fixed-point output (a - b)
);

    // Extract sign bits
    wire a_sign = a[N-1];
    wire b_sign = b[N-1];

    // Compute absolute values of a and b once
    wire [N-1:0] a_abs = a_sign ? (~a + 1'b1) : a;
    wire [N-1:0] b_abs = b_sign ? (~b + 1'b1) : b;

    // Precompute magnitude comparisons to avoid redundant computations
    wire a_ge_b = (a_abs >= b_abs);
    wire a_gt_b = (a_abs >  b_abs);

    // Internal magnitude result and sign
    reg [N-1:0] mag_res;
    reg         res_sign;

    always @* begin
        // Reset outputs to default safe values
        mag_res = {N{1'b0}};
        res_sign = 1'b0;

        if (a_sign == b_sign) begin
            // Same sign subtraction: result magnitude = |a| - |b|
            if (a_ge_b) begin
                mag_res = a_abs - b_abs;
                res_sign = a_sign; // sign same as inputs
            end else begin
                mag_res = b_abs - a_abs;
                res_sign = ~a_sign; // opposite sign if |a| < |b|
            end
        end else begin
            // Different signs: result magnitude = |a| + |b|
            mag_res = a_abs + b_abs;

            // Sign determination
            if (a_sign == 1'b0 && b_sign == 1'b1) begin
                // a positive, b negative
                // result sign positive if a_abs >= b_abs else negative
                res_sign = a_ge_b ? 1'b0 : 1'b1;
            end else begin
                // a negative, b positive
                // result sign negative if a_abs > b_abs else positive
                res_sign = a_gt_b ? 1'b1 : 1'b0;
            end
        end

        // Convert sign+magnitude to two's complement representation
        // Special case for zero to ensure sign bit is 0 explicitly
        if (mag_res == {N{1'b0}}) begin
            c = {1'b0, {(N-1){1'b0}}}; // zero with positive sign bit
        end else if (res_sign) begin
            // Negative result: two's complement
            c = (~mag_res) + 1'b1;
        end else begin
            // Positive result: direct magnitude
            c = mag_res;
        end
    end

endmodule

/*
Example parameterized instantiation to avoid elaboration errors:

fixed_point_subtractor #(
    .Q(8),    // Number of fractional bits
    .N(16)    // Total width bits
) uut (
    .a(a_signal),
    .b(b_signal),
    .c(c_signal)
);

Ensure to pass parameters explicitly matching your data widths
to avoid parameter mismatch or elaboration errors in simulators or synthesis tools.
*/