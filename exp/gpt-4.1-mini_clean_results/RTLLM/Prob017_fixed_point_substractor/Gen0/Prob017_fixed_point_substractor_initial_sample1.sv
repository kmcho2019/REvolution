module fixed_point_subtractor #(
    parameter integer Q = 8,      // Number of fractional bits
    parameter integer N = 16      // Total bits width
)(
    input  wire [N-1:0] a,
    input  wire [N-1:0] b,
    output reg  [N-1:0] c
);

    reg [N-1:0] res;

    // Internal signals
    wire sign_a = a[N-1];
    wire sign_b = b[N-1];

    // Absolute values of a and b (remove sign)
    wire [N-1:0] abs_a = sign_a ? (~a + 1'b1) : a;
    wire [N-1:0] abs_b = sign_b ? (~b + 1'b1) : b;

    // Compare absolute values
    wire a_gt_b = (abs_a > abs_b);
    wire abs_eq = (abs_a == abs_b);

    always @* begin
        if (sign_a == sign_b) begin
            // Same sign: perform a - b
            // a and b have same sign, so subtraction keeps that sign
            // Perform subtraction on absolute values with sign
            // Because same sign, c = a - b with sign_a
            if (abs_a >= abs_b) begin
                res = abs_a - abs_b;
                // Sign same as inputs
                if (sign_a)
                    res = (~res + 1'b1); // make negative by two's complement
            end else begin
                res = abs_b - abs_a;
                // Sign is opposite of inputs because result negative relative to a-b order
                if (!sign_a)
                    res = (~res + 1'b1);
                else
                    res = (~res + 1'b1);
                // Actually when abs_b > abs_a and same sign inputs, result sign flips compared to inputs
                // So, if sign_a=0 and abs_b>abs_a => result negative (sign=1)
                // if sign_a=1 and abs_b>abs_a => result positive (sign=0)
                // So above logic needs correction to assign sign properly
                // Simplify:
                // If sign_a=0 (inputs positive), and abs_b > abs_a => c = negative => sign=1
                // If sign_a=1 (inputs negative), and abs_b > abs_a => c = positive => sign=0
                // So:
                if (sign_a == 0)
                    res = (~res + 1'b1); // negative
                else
                    ; // res already positive, no change
            end
        end else begin
            // Different signs: add absolute values
            // Result sign depends on magnitude comparison
            res = abs_a + abs_b;
            if (sign_a == 0 && sign_b == 1) begin
                // a positive, b negative
                // result sign positive if abs_a > abs_b else negative
                if (a_gt_b)
                    ; // sign positive (0), res as is
                else if (abs_eq) begin
                    // zero result
                    res = 0;
                end else begin
                    // sign negative
                    res = (~res + 1'b1);
                end
            end else if (sign_a == 1 && sign_b == 0) begin
                // a negative, b positive
                // result sign negative if abs_a > abs_b else positive
                if (a_gt_b)
                    res = (~res + 1'b1); // negative
                else if (abs_eq) begin
                    // zero result
                    res = 0;
                end else
                    ; // sign positive, res as is
            end else begin
                // Should never get here because signs differ only
                res = 0;
            end
        end

        // Handle zero: if result is zero clear sign bit explicitly
        if (res == 0)
            c = {1'b0, {N-1{1'b0}}};
        else
            c = res;
    end

endmodule