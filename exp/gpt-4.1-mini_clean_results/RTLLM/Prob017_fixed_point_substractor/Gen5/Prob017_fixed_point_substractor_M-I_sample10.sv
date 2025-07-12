module fixed_point_subtractor #(
    parameter Q = 8,           // Number of fractional bits
    parameter N = 16           // Total number of bits (integer + fractional)
)(
    input  wire [N-1:0] a,    // First operand
    input  wire [N-1:0] b,    // Second operand
    output reg  [N-1:0] c     // Result output
);

    // Extract sign bits (MSB)
    wire a_sign = a[N-1];
    wire b_sign = b[N-1];

    // Compute absolute values using two's complement if negative
    wire [N-1:0] a_abs = a_sign ? (~a + 1'b1) : a;
    wire [N-1:0] b_abs = b_sign ? (~b + 1'b1) : b;

    // Magnitude comparison
    wire a_ge_b = (a_abs >= b_abs);

    reg [N-1:0] mag_res;
    reg         res_sign;

    // Zero detection on magnitude (wire for optimal synthesis)
    wire zero_detect;

    always @* begin
        if (a_sign == b_sign) begin
            // Same sign subtraction: |a| - |b|
            if (a_ge_b) begin
                mag_res  = a_abs - b_abs;
                res_sign = a_sign;        // result sign same as inputs
            end else begin
                mag_res  = b_abs - a_abs;
                res_sign = ~a_sign;       // opposite sign
            end
        end else begin
            // Different sign addition: |a| + |b|
            mag_res = a_abs + b_abs;
            // Determine sign based on signs and magnitude
            if (~a_sign && b_sign) begin
                // a positive, b negative
                res_sign = a_ge_b ? 1'b0 : 1'b1;
            end else begin
                // a negative, b positive
                res_sign = a_ge_b ? 1'b1 : 1'b0;
            end
        end
    end

    // Zero detection: zero_detect is 1 if mag_res == 0
    assign zero_detect = ~|mag_res;

    always @* begin
        if (zero_detect) begin
            // Zero result: clear sign bit explicitly
            c = {1'b0, {N-1{1'b0}}};
        end else if (res_sign) begin
            // Negative result: two's complement of magnitude
            c = (~mag_res) + 1'b1;
        end else begin
            // Positive result: magnitude as is
            c = mag_res;
        end
    end

endmodule