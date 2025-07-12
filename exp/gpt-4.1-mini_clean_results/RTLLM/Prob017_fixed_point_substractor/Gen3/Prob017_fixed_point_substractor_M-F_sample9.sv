module fixed_point_subtractor #(parameter Q = 8, parameter N = 16) (
    input  wire [N-1:0] a,
    input  wire [N-1:0] b,
    output reg  [N-1:0] c
);
    // Internal register for result
    reg [N-1:0] res;

    // Temporary register for sum of absolute values (for different sign case)
    reg [N-1:0] sum_abs;

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
            // Same sign: subtract b from a directly (two's complement)
            res = a - b;
        end else begin
            // Different signs: add absolute values
            sum_abs = a_abs + b_abs;

            if (a_sign == 1'b0 && b_sign == 1'b1) begin
                // a positive, b negative
                if (a_greater_or_equal)
                    res = sum_abs; // positive number, sign bit 0 naturally
                else
                    res = (~sum_abs + 1'b1); // negative two's complement
            end else if (a_sign == 1'b1 && b_sign == 1'b0) begin
                // a negative, b positive
                if (a_greater_or_equal)
                    res = (~sum_abs + 1'b1); // negative two's complement
                else
                    res = sum_abs; // positive number
            end else begin
                // Should never occur, fallback subtraction
                res = a - b;
            end
        end

        // Handle zero result: explicitly clear sign bit
        if (res == {N{1'b0}}) begin
            res[N-1] = 1'b0;
        end

        c = res;
    end

endmodule