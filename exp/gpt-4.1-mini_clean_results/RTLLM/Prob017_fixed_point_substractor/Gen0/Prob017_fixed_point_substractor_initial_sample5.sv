module fixed_point_subtractor #(parameter Q = 8, parameter N = 16)(
    input  wire [N-1:0] a,
    input  wire [N-1:0] b,
    output wire [N-1:0] c
);

    // Internal register to hold the result
    reg [N-1:0] res;

    // Extract sign bits
    wire a_sign = a[N-1];
    wire b_sign = b[N-1];

    // Function to get absolute value of fixed-point number (N bits two's complement)
    function [N-1:0] abs_val(input [N-1:0] val);
        begin
            if (val[N-1]) // negative
                abs_val = (~val) + 1'b1;
            else
                abs_val = val;
        end
    endfunction

    // Compare magnitudes: returns 1 if a_mag >= b_mag else 0
    function a_ge_b(input [N-1:0] a_mag, input [N-1:0] b_mag);
        begin
            a_ge_b = (a_mag >= b_mag);
        end
    endfunction

    // Combinational logic block
    always @* begin
        if (a_sign == b_sign) begin
            // Same sign subtraction: res = a - b, sign same as inputs
            res = a - b;
        end else begin
            // Different sign: add absolute values and set sign accordingly
            // Compute absolute values
            wire [N-1:0] a_abs = abs_val(a);
            wire [N-1:0] b_abs = abs_val(b);
            // Compare absolute values
            if (a_ge_b(a_abs, b_abs)) begin
                // |a| >= |b|, sign is a_sign
                // res magnitude = |a| + |b|
                // Since subtraction with different signs is effectively addition of magnitudes
                // Wait: careful - the problem states:
                // If a is positive and b negative: result = a + abs(b)
                // If a is negative and b positive: result = -(abs(a)+b)
                // but that is inconsistent with "subtract" operation; the question wants:
                // Different Sign Subtraction:
                // If a is positive and b negative: add abs values; sign positive if a > b else negative
                // If a is negative and b positive: add abs values; sign negative if abs(a) > b else positive

                // So the logic:
                // If a_sign=0, b_sign=1: a positive b negative
                //   res = a_abs + b_abs, sign = 0
                // If a_sign=1, b_sign=0: a negative b positive
                //   res = a_abs + b_abs, sign = 1

                // So res magnitude = a_abs + b_abs
                // sign depends on a_sign and magnitude comparison

                // Implement this:
                // magnitude sum:
                wire [N-1:0] sum_mag = a_abs + b_abs;

                if (a_sign == 1'b0 && b_sign == 1'b1) begin
                    // a positive, b negative
                    // sign positive if a_abs >= b_abs else negative
                    if (a_ge_b(a_abs, b_abs))
                        res = sum_mag; // sign 0 positive
                    else
                        res = (~sum_mag) + 1'b1; // negative sign
                end else if (a_sign == 1'b1 && b_sign == 1'b0) begin
                    // a negative, b positive
                    // sign negative if a_abs >= b_abs else positive
                    if (a_ge_b(a_abs, b_abs))
                        res = (~sum_mag) + 1'b1; // negative sign
                    else
                        res = sum_mag; // positive sign
                end else begin
                    // Should never occur
                    res = {N{1'b0}};
                end
            end else begin
                // |a| < |b|, sign flipped from above

                // magnitude sum:
                wire [N-1:0] sum_mag = abs_val(a) + abs_val(b);

                if (a_sign == 1'b0 && b_sign == 1'b1) begin
                    // a positive, b negative
                    // sign positive if a_abs >= b_abs else negative
                    // Here a_abs < b_abs, so sign negative
                    res = (~sum_mag) + 1'b1;
                end else if (a_sign == 1'b1 && b_sign == 1'b0) begin
                    // a negative, b positive
                    // sign negative if a_abs >= b_abs else positive
                    // Here a_abs < b_abs, so sign positive
                    res = sum_mag;
                end else begin
                    res = {N{1'b0}};
                end
            end
        end

        // Handle zero case: explicitly set sign bit to 0 if result is zero
        if (res == {N{1'b0}})
            res[N-1] = 1'b0;
    end

    // Assign output
    assign c = res;

endmodule