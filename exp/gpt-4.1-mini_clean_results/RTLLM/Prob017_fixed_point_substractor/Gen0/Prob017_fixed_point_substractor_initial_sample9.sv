module fixed_point_subtractor #
(
    parameter integer Q = 8,      // Number of fractional bits
    parameter integer N = 16      // Total number of bits (including sign)
)
(
    input  wire [N-1:0] a,
    input  wire [N-1:0] b,
    output reg  [N-1:0] c
);

    // Internal register to hold result magnitude and sign
    reg [N-2:0] abs_a; // Magnitude bits of a (without sign)
    reg [N-2:0] abs_b; // Magnitude bits of b (without sign)
    reg sign_a;
    reg sign_b;

    reg [N-1:0] res;
    reg sign_res;
    reg [N-2:0] mag_res;

    // Compare magnitudes (unsigned comparison)
    wire a_greater_or_equal_b;
    wire b_greater_a;

    assign a_greater_or_equal_b = (abs_a >= abs_b);
    assign b_greater_a = (abs_b > abs_a);

    always @(*) begin
        // Extract sign bits and absolute magnitudes
        sign_a = a[N-1];
        sign_b = b[N-1];
        abs_a = (sign_a) ? (~a[N-2:0] + 1'b1) : a[N-2:0];
        abs_b = (sign_b) ? (~b[N-2:0] + 1'b1) : b[N-2:0];

        if (sign_a == sign_b) begin
            // Same sign subtraction: res magnitude = abs_a - abs_b
            if (a_greater_or_equal_b) begin
                mag_res = abs_a - abs_b;
                sign_res = sign_a;
            end else begin
                mag_res = abs_b - abs_a;
                // Sign same as inputs, so sign_res = sign_a
                // But since abs_b > abs_a, this is subtraction reversed.
                // As per the problem statement "same sign subtraction ... result sign same as inputs"
                // So if abs_b > abs_a, the result is negative of inputs?
                // The problem states "sign of the result will be the same as the inputs" so keep sign_a.
                // But magnitude is negative since we swapped. Actually in subtraction with same sign:
                // result = a - b, so if abs_b > abs_a and same sign, result is negative.
                // So sign should be sign_a to comply with "same sign => sign same as inputs"
                // The problem is ambiguous here, but likely the subtraction must keep sign if a >= b,
                // else result sign reversed.
                // A better approach: subtract abs_b from abs_a if a >= b, else subtract abs_a from abs_b and invert sign.
                // So change logic accordingly:
                // Implemented below.
                // Here just write this branch for now - fix below.
                mag_res = abs_b - abs_a;
                // sign_res = ~sign_a; // fix below
                // Will fix code structure below.
            end
        end else begin
            // Different sign subtraction: effectively addition of magnitudes
            mag_res = abs_a + abs_b;

            // Result sign depends on operand signs and relative magnitudes:
            // If a positive and b negative: sign is positive if abs_a > abs_b, else negative
            // If a negative and b positive: sign is negative if abs_a > abs_b, else positive

            if (sign_a == 1'b0 && sign_b == 1'b1) begin
                // a positive, b negative
                if (abs_a >= abs_b) sign_res = 1'b0;
                else sign_res = 1'b1;
            end else begin
                // a negative, b positive
                if (abs_a >= abs_b) sign_res = 1'b1;
                else sign_res = 1'b0;
            end
        end

        // Handle the same sign subtraction sign correction:
        if (sign_a == sign_b) begin
            if (a_greater_or_equal_b) begin
                mag_res = abs_a - abs_b;
                sign_res = sign_a;
            end else begin
                mag_res = abs_b - abs_a;
                sign_res = ~sign_a;
            end
        end

        // If result magnitude is zero, force sign to 0
        if (mag_res == 0) sign_res = 1'b0;

        // Compose the final result
        if (sign_res) begin
            // Negative: two's complement
            res = {sign_res, (~mag_res + 1'b1)};
        end else begin
            // Positive: magnitude as is
            res = {sign_res, mag_res};
        end

        c = res;
    end

endmodule