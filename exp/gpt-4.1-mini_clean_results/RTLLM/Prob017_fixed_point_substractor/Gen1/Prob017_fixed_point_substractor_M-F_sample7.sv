module fixed_point_subtractor #(parameter Q = 8, parameter N = 16) (
    input  wire [N-1:0] a,
    input  wire [N-1:0] b,
    output reg  [N-1:0] c
);

    reg [N-1:0] res;

    // Intermediate variables declared at module scope (not inside always block)
    reg sign_a;
    reg sign_b;
    reg [N-1:0] abs_a;
    reg [N-1:0] abs_b;
    reg       res_sign;
    reg [N-1:0] mag_sum;

    // Function to compute absolute value of N-bit signed number in two's complement
    function [N-1:0] abs_val;
        input [N-1:0] in;
        begin
            if (in[N-1] == 1'b1)
                abs_val = (~in) + 1'b1; // Two's complement negate
            else
                abs_val = in;
        end
    endfunction

    // Compare magnitude of two N-bit signed numbers by absolute value
    function is_a_gt_b;
        input [N-1:0] a_in;
        input [N-1:0] b_in;
        begin
            if (abs_val(a_in) > abs_val(b_in))
                is_a_gt_b = 1'b1;
            else
                is_a_gt_b = 1'b0;
        end
    endfunction

    always @(*) begin
        sign_a = a[N-1];
        sign_b = b[N-1];

        if (sign_a == sign_b) begin
            // Same sign subtraction: res = a - b
            res = a - b;
        end else begin
            // Different signs, add absolute values
            abs_a = abs_val(a);
            abs_b = abs_val(b);
            mag_sum = abs_a + abs_b;

            if (is_a_gt_b(a,b)) begin
                res_sign = sign_a;
            end else if (abs_a == abs_b) begin
                // Equal magnitude means zero result
                mag_sum = {N{1'b0}};
                res_sign = 1'b0;
            end else begin
                res_sign = sign_b;
            end

            // Apply sign by two's complement negation if negative
            if (res_sign == 1'b1)
                res = (~mag_sum) + 1'b1;
            else
                res = mag_sum;
        end

        // Explicitly clear sign bit if result is zero to avoid negative zero
        if (res == {N{1'b0}})
            res[N-1] = 1'b0;

        c = res;
    end

endmodule