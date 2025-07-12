module fixed_point_subtractor #(
    parameter Q = 8,            // Number of fractional bits
    parameter N = 16            // Total bits (integer + fractional)
)(
    input  wire signed [N-1:0] a,     // First fixed-point operand (signed)
    input  wire signed [N-1:0] b,     // Second fixed-point operand (signed)
    output reg  signed [N-1:0] c      // Fixed-point subtraction result (signed)
);

    localparam MSB = N-1;       // Most significant bit index (sign bit)

    // Extract sign bits
    wire a_sign = a[MSB];
    wire b_sign = b[MSB];

    // Compute absolute values of inputs
    wire [N-1:0] a_abs = a_sign ? (~a + 1'b1) : a;
    wire [N-1:0] b_abs = b_sign ? (~b + 1'b1) : b;

    // Compare magnitudes (unsigned comparison)
    wire a_ge_b = (a_abs >= b_abs);

    // Intermediate magnitude result (unsigned)
    reg [N-1:0] res_val;

    // Result sign flag: 0 = positive, 1 = negative
    reg res_sign;

    // Zero detection for magnitude result
    wire zero_detect;

    always @* begin
        // Compute magnitude and sign based on input signs and magnitudes
        if (a_sign == b_sign) begin
            // Same sign: subtract magnitudes
            if (a_ge_b) begin
                res_val = a_abs - b_abs;
                res_sign = a_sign;  // Result sign same as inputs
            end else begin
                res_val = b_abs - a_abs;
                res_sign = ~a_sign; // Opposite sign of inputs
            end
        end else begin
            // Different sign: add magnitudes
            res_val = a_abs + b_abs;
            // Determine sign based on which magnitude is larger and signs
            if (~a_sign && b_sign) begin
                // a positive, b negative
                res_sign = a_ge_b ? 1'b0 : 1'b1;
            end else begin
                // a negative, b positive
                res_sign = a_ge_b ? 1'b1 : 1'b0;
            end
        end
    end

    assign zero_detect = (res_val == 0);

    always @* begin
        if (zero_detect) begin
            // Explicit zero with sign bit zero
            c = {1'b0, {(N-1){1'b0}}};
        end else if (res_sign) begin
            // Negative result: two's complement magnitude
            c = -$signed(res_val);
        end else begin
            // Positive result: as is
            c = $signed(res_val);
        end
    end

endmodule