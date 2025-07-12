module fixed_point_subtractor #(parameter Q = 8, parameter N = 16)(
    input  wire [N-1:0] a,
    input  wire [N-1:0] b,
    output wire [N-1:0] c
);

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

    // Absolute values of inputs (combinational)
    wire [N-1:0] a_abs = abs_val(a);
    wire [N-1:0] b_abs = abs_val(b);

    // Compare magnitudes (combinational)
    wire a_ge_b = (a_abs >= b_abs);

    // Sum of absolute values (combinational)
    wire [N-1:0] sum_abs = a_abs + b_abs;

    // Internal register to hold the result
    reg [N-1:0] res;

    // Combinational logic block
    always @* begin
        if (a_sign == b_sign) begin
            // Same sign subtraction: res = a - b, sign same as inputs
            res = a - b;
        end else begin
            // Different sign: effective addition of magnitudes with sign logic
            if (a_sign == 1'b0 && b_sign == 1'b1) begin
                // a positive, b negative
                if (a_ge_b)
                    res = sum_abs;          // positive result
                else
                    res = (~sum_abs) + 1'b1; // negative result (two's complement)
            end else if (a_sign == 1'b1 && b_sign == 1'b0) begin
                // a negative, b positive
                if (a_ge_b)
                    res = (~sum_abs) + 1'b1; // negative result
                else
                    res = sum_abs;           // positive result
            end else begin
                // Defensive fallback (should not occur)
                res = {N{1'b0}};
            end
        end

        // Handle zero case: explicitly set sign bit to 0 if result is zero
        if (res == {N{1'b0}})
            res[N-1] = 1'b0;
    end

    // Assign output
    assign c = res;

endmodule