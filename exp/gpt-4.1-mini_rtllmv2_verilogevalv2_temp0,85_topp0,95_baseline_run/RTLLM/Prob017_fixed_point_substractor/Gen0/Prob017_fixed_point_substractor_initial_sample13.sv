module fixed_point_subtractor #(parameter Q = 8, parameter N = 16)(
    input  wire [N-1:0] a,
    input  wire [N-1:0] b,
    output reg  [N-1:0] c
);

    // Internal register for result
    reg [N-1:0] res;

    // Extract sign bits
    wire a_sign = a[N-1];
    wire b_sign = b[N-1];

    // Function to compute absolute value of a two's complement number
    function [N-1:0] abs_val;
        input [N-1:0] val;
        begin
            if (val[N-1] == 1'b1)
                abs_val = (~val) + 1'b1;
            else
                abs_val = val;
        end
    endfunction

    // Compare magnitudes of two unsigned numbers (assumed absolute values)
    function mag_greater_equal;
        input [N-1:0] x;
        input [N-1:0] y;
        begin
            mag_greater_equal = (x >= y);
        end
    endfunction

    always @(*) begin
        if (a_sign == b_sign) begin
            // Same sign subtraction: c = a - b
            res = a - b;
        end else begin
            // Different sign subtraction means addition of absolute values
            // Determine abs values
            reg [N-1:0] abs_a;
            reg [N-1:0] abs_b;
            abs_a = abs_val(a);
            abs_b = abs_val(b);

            if (a_sign == 1'b0 && b_sign == 1'b1) begin
                // a positive, b negative: c = a + |b|, sign positive if a >= |b|
                if (mag_greater_equal(abs_a, abs_b)) begin
                    // result positive: res = abs_a + abs_b
                    res = abs_a + abs_b;
                end else begin
                    // result negative: res = - (abs_b - abs_a)
                    // compute magnitude: abs_b - abs_a
                    reg [N-1:0] diff;
                    diff = abs_b - abs_a;
                    // res = two's complement of diff
                    res = (~diff) + 1'b1;
                end
            end else if (a_sign == 1'b1 && b_sign == 1'b0) begin
                // a negative, b positive: c = -|a| - b
                // equivalently, c = - (|a| + b)
                if (mag_greater_equal(abs_a, abs_b)) begin
                    // result negative: - (abs_a + abs_b)
                    reg [N-1:0] sum;
                    sum = abs_a + abs_b;
                    res = (~sum) + 1'b1;
                end else begin
                    // result positive: abs_b - abs_a
                    res = abs_b - abs_a;
                end
            end else begin
                // Should never happen, but default to zero
                res = {N{1'b0}};
            end
        end

        // Handling zero result: force sign bit to 0
        if (res == {N{1'b0}}) begin
            res[N-1] = 1'b0;
        end

        c = res;
    end

endmodule