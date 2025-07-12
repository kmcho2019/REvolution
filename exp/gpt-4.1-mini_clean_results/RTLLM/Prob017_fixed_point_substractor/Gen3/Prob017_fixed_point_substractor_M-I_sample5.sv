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

    // Compute absolute values of a and b
    wire [N-1:0] a_abs = a_sign ? (~a + 1'b1) : a;
    wire [N-1:0] b_abs = b_sign ? (~b + 1'b1) : b;

    reg [N-1:0] mag_res;
    reg        res_sign;

    always @* begin
        if (a_sign == b_sign) begin
            // Same sign subtraction: |a| - |b|
            if (a_abs >= b_abs) begin
                mag_res = a_abs - b_abs;
                res_sign = a_sign; // sign same as inputs
            end else begin
                mag_res = b_abs - a_abs;
                res_sign = ~a_sign; // opposite sign because a_abs < b_abs
            end
        end else begin
            // Different signs: |a| + |b|
            mag_res = a_abs + b_abs;

            // Determine sign based on magnitude comparison:
            // If a is positive and b negative:
            //   result sign positive if a_abs >= b_abs else negative
            // If a is negative and b positive:
            //   result sign negative if a_abs > b_abs else positive
            if (a_sign == 1'b0 && b_sign == 1'b1) begin
                // a positive, b negative
                res_sign = (a_abs >= b_abs) ? 1'b0 : 1'b1;
            end else begin
                // a negative, b positive
                res_sign = (a_abs > b_abs) ? 1'b1 : 1'b0;
            end
        end

        // Convert magnitude + sign back to two's complement
        if (mag_res == {N{1'b0}}) begin
            // zero result, sign bit forced to zero
            c = {1'b0, {N-1{1'b0}}};
        end else if (res_sign) begin
            // Negative result: two's complement
            c = (~mag_res) + 1'b1;
        end else begin
            // Positive result
            c = mag_res;
        end
    end

endmodule