module fixed_point_subtractor #(parameter Q = 8, parameter N = 16) (
    input  wire [N-1:0] a,
    input  wire [N-1:0] b,
    output reg  [N-1:0] c
);
    // Internal register for result
    reg [N-1:0] res;

    // Extract sign bits
    wire a_sign = a[N-1];
    wire b_sign = b[N-1];

    // Function to compute absolute value (two's complement)
    function [N-1:0] abs_val;
        input [N-1:0] val;
        begin
            abs_val = val[N-1] ? (~val + 1'b1) : val;
        end
    endfunction

    // Magnitudes of a and b
    wire [N-1:0] a_abs = abs_val(a);
    wire [N-1:0] b_abs = abs_val(b);

    // Compare absolute values
    wire a_greater_or_equal = (a_abs >= b_abs);

    always @* begin
        if (a_sign == b_sign) begin
            // Same sign: subtract magnitudes, keep sign
            if (a_abs >= b_abs) begin
                // result magnitude = a_abs - b_abs
                res = {a_sign, (a_abs - b_abs)[N-2:0]};
            end else begin
                // result magnitude = b_abs - a_abs
                // sign same as inputs but swapped to negative because a<b
                // But problem states sign same as inputs
                // So, when same sign and b > a, result should have same sign but negative magnitude? 
                // No, in two's complement, sign bit is the MSB of the final difference.
                // To keep sign same, just do a-b; sign will be auto handled by two's complement subtraction
                // Instead of manual magnitude subtraction, better to do a - b directly here
                // But spec says same sign subtraction: subtract fractional and integer parts with sign of inputs.
                // So, we can do res = a - b directly
                res = a - b;
            end
        end else begin
            // Different signs: add absolute values
            reg [N-1:0] sum_abs;
            sum_abs = a_abs + b_abs;

            // Determine sign of result:
            // If a positive & b negative: sign depends on a_abs >= b_abs -> positive or negative
            // If a negative & b positive: sign depends on a_abs >= b_abs -> negative or positive
            if (a_sign == 1'b0 && b_sign == 1'b1) begin
                // a positive, b negative
                if (a_greater_or_equal)
                    res = {1'b0, sum_abs[N-2:0]}; // positive sign
                else
                    res = (~{1'b0, sum_abs[N-2:0]} + 1'b1); // negative sign (two's complement)
            end else if (a_sign == 1'b1 && b_sign == 1'b0) begin
                // a negative, b positive
                if (a_greater_or_equal)
                    res = {1'b1, sum_abs[N-2:0]}; // negative sign
                else
                    res = (~{1'b1, sum_abs[N-2:0]} + 1'b1); // positive sign (two's complement)
            end else begin
                // Should never be here
                res = a - b;
            end
        end

        // Handle zero result: explicitly set sign bit to 0
        if (res == {N{1'b0}}) begin
            res[N-1] = 1'b0;
        end

        c = res;
    end

endmodule