module fixed_point_subtractor #(
    parameter Q = 8,           // Number of fractional bits
    parameter N = 16           // Total number of bits (integer + fractional)
)(
    input  wire [N-1:0] a,    // First operand
    input  wire [N-1:0] b,    // Second operand
    output reg  [N-1:0] c     // Result output
);

    // Extract sign bits
    wire a_sign = a[N-1];
    wire b_sign = b[N-1];

    // Compute absolute values
    wire [N-1:0] a_abs = a_sign ? (~a + 1'b1) : a;
    wire [N-1:0] b_abs = b_sign ? (~b + 1'b1) : b;

    // Precompute comparisons
    wire a_ge_b = (a_abs >= b_abs);
    wire a_gt_b = (a_abs >  b_abs);

    // Intermediate magnitude and sign
    reg [N-1:0] mag_res;
    reg         res_sign;

    wire zero_detect;

    always @* begin
        if (a_sign == b_sign) begin
            // Same sign subtraction: |a| - |b|
            if (a_ge_b) begin
                mag_res  = a_abs - b_abs;
                res_sign = a_sign;        // sign same as inputs
            end else begin
                mag_res  = b_abs - a_abs;
                res_sign = ~a_sign;       // opposite sign
            end
        end else begin
            // Different signs: |a| + |b|
            mag_res = a_abs + b_abs;

            // Determine sign based on sign and magnitude
            if (~a_sign && b_sign) begin
                // a positive, b negative
                res_sign = a_ge_b ? 1'b0 : 1'b1;
            end else begin
                // a negative, b positive
                res_sign = a_gt_b ? 1'b1 : 1'b0;
            end
        end

        // Zero detection for magnitude
        // Using reduction OR to detect if mag_res is zero
        // zero_detect is true if mag_res == 0
        // assign in always block to keep all together
        // (this could be wire outside but for clarity here)
        if (mag_res == {N{1'b0}})
            zero_detect = 1'b1;
        else
            zero_detect = 1'b0;

        // Assign output c in two's complement form
        if (zero_detect) begin
            c = {1'b0, {N-1{1'b0}}};  // zero with sign bit cleared
        end else if (res_sign) begin
            // Negative number, convert magnitude to two's complement
            c = (~mag_res) + 1'b1;
        end else begin
            // Positive number
            c = mag_res;
        end
    end

endmodule