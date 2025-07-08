module fixed_point_subtractor #(
    parameter Q = 8,  // Number of fractional bits
    parameter N = 16  // Total number of bits (integer + fractional + sign)
)(
    input  wire [N-1:0] a,
    input  wire [N-1:0] b,
    output reg  [N-1:0] c
);

    reg [N-1:0] res;

    wire sign_a = a[N-1];
    wire sign_b = b[N-1];

    // Function to compute absolute value of signed number in two's complement
    function [N-1:0] abs_val;
        input [N-1:0] val;
        begin
            if (val[N-1] == 1'b1)
                abs_val = (~val + 1'b1);
            else
                abs_val = val;
        end
    endfunction

    wire [N-1:0] abs_a = abs_val(a);
    wire [N-1:0] abs_b = abs_val(b);

    reg [N-1:0] temp_res;
    reg        result_sign;

    always @(*) begin
        if (sign_a == sign_b) begin
            // Same sign: subtract b from a
            temp_res = a - b;
            result_sign = temp_res[N-1];
            // According to spec, sign of result matches inputs (same sign)
            // But subtraction might flip sign if |b| > |a|
            // We'll trust the direct subtraction result sign here as it matches two's complement subtraction
        end else begin
            // Different sign: effectively add absolute values
            if (sign_a == 1'b0 && sign_b == 1'b1) begin
                // a positive, b negative => a - (-b) = a + |b|
                // Result sign depends on whether a >= |b|
                if (abs_a >= abs_b) begin
                    temp_res = abs_a + abs_b;
                    result_sign = 1'b0;
                end else begin
                    temp_res = abs_b + abs_a;
                    result_sign = 1'b1;
                end
                // Actually adding abs_a + abs_b twice is redundant, but preserves logic clarity.
            end else if (sign_a == 1'b1 && sign_b == 1'b0) begin
                // a negative, b positive => (-a) - b = - (|a| + b)
                // Result sign depends on whether |a| >= b
                if (abs_a >= abs_b) begin
                    temp_res = abs_a + abs_b;
                    result_sign = 1'b1;
                end else begin
                    temp_res = abs_b + abs_a;
                    result_sign = 1'b0;
                end
            end else begin
                // Should not occur, but default safe assignment
                temp_res = a - b;
                result_sign = temp_res[N-1];
            end

            // Now temp_res is magnitude, need to add sign
            // Convert magnitude back to two's complement with result_sign
            if (result_sign == 1'b1) begin
                // negative: two's complement of temp_res magnitude
                temp_res = (~temp_res + 1'b1);
            end
        end

        // Handle zero result case: set sign bit to 0 explicitly
        if (temp_res == {N{1'b0}}) begin
            res = {1'b0, {(N-1){1'b0}}};
        end else begin
            res = temp_res;
        end
    end

    always @(*) begin
        c = res;
    end

endmodule