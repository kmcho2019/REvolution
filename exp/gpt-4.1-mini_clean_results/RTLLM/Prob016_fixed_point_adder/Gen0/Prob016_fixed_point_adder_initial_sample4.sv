module fixed_point_adder #(parameter Q = 8, parameter N = 16) (
    input  wire [N-1:0] a,
    input  wire [N-1:0] b,
    output reg  [N-1:0] c
);

    reg [N-1:0] res;

    // Function to get absolute value of fixed-point number (N-bit two's complement)
    function [N-1:0] abs_val;
        input [N-1:0] val;
        begin
            if (val[N-1] == 1'b1)
                abs_val = (~val) + 1'b1;
            else
                abs_val = val;
        end
    endfunction

    // Function to compare absolute values: returns 1 if abs(a) >= abs(b)
    function abs_ge;
        input [N-1:0] val_a, val_b;
        begin
            abs_ge = (abs_val(val_a) >= abs_val(val_b));
        end
    endfunction

    always @* begin
        // Extract sign bits
        wire a_sign = a[N-1];
        wire b_sign = b[N-1];
        reg [N-1:0] abs_a;
        reg [N-1:0] abs_b;

        abs_a = abs_val(a);
        abs_b = abs_val(b);

        if (a_sign == b_sign) begin
            // Same sign: add absolute values
            res = abs_a + abs_b;

            // Handle possible carry out (overflow) by truncation
            // No explicit saturation; result truncated to N bits naturally

            // Set sign bit of result same as a_sign and b_sign
            if (res[N-1] == 1'b1) begin
                // If addition overflowed MSB (sign bit flipped), 
                // the result is truncated to N bits which wraps around,
                // this is natural two's complement overflow behavior
                // No saturation implemented per instructions
            end

            // Assign sign back:
            // If res overflows sign bit, it will naturally appear in result as 2's complement
            // So no manual override needed, just reapply sign by re-sign extending sum.

            // But since res is sum of abs values, MSB might flip unexpectedly.
            // To force sign, we reconstruct res as signed magnitude:

            // Actually, to ensure result sign matches operands' sign:
            if (a_sign == 1'b1)
                // Negative result: take two's complement of res
                c = (~res) + 1'b1;
            else
                c = res;

        end else begin
            // Different signs: subtract smaller abs from larger abs

            if (abs_ge(a, b)) begin
                // abs(a) >= abs(b), result sign is a_sign (which is 0 here since signs differ)
                res = abs_a - abs_b;

                if (res == 0)
                    c = {N{1'b0}}; // zero output
                else begin
                    if (a_sign == 1'b0)
                        c = res;   // positive result
                    else
                        c = (~res) + 1'b1;  // negative result: two's complement
                end
            end else begin
                // abs(b) > abs(a), result sign is b_sign

                res = abs_b - abs_a;

                if (res == 0)
                    c = {N{1'b0}}; // zero output
                else begin
                    if (b_sign == 1'b0)
                        c = res;   // positive result
                    else
                        c = (~res) + 1'b1;  // negative result: two's complement
                end
            end
        end
    end

endmodule