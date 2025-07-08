module fixed_point_adder #(parameter Q = 8, parameter N = 16) (
    input  wire [N-1:0] a,
    input  wire [N-1:0] b,
    output reg  [N-1:0] c
);

    reg [N-1:0] res;

    // Function to compute absolute value of fixed-point number
    function [N-1:0] abs_val;
        input [N-1:0] val;
        begin
            if (val[N-1] == 1'b1)
                abs_val = (~val) + 1'b1; // two's complement negation
            else
                abs_val = val;
        end
    endfunction

    // Compare absolute values: returns 1 if abs(a) >= abs(b), else 0
    function abs_ge;
        input [N-1:0] a_val;
        input [N-1:0] b_val;
        reg [N-1:0] abs_a;
        reg [N-1:0] abs_b;
        begin
            abs_a = abs_val(a_val);
            abs_b = abs_val(b_val);
            abs_ge = (abs_a >= abs_b);
        end
    endfunction

    // Main combinational logic
    always @(*) begin
        // Extract sign bits
        wire sign_a = a[N-1];
        wire sign_b = b[N-1];

        reg [N-1:0] abs_a = abs_val(a);
        reg [N-1:0] abs_b = abs_val(b);

        if (sign_a == sign_b) begin
            // Same sign: result = abs(a) + abs(b) with sign = sign_a
            res = abs_a + abs_b;
            // Handle overflow by truncation (natural in fixed width)
            res[N-1] = sign_a;
        end else begin
            // Different signs: subtract smaller absolute from larger absolute
            if (abs_ge(a, b)) begin
                res = abs_a - abs_b;
                // If result zero, sign is 0 (positive), else sign is sign of a (which is 1 if negative)
                if (res == 0)
                    res[N-1] = 1'b0;
                else
                    res[N-1] = sign_a;
            end else begin
                res = abs_b - abs_a;
                if (res == 0)
                    res[N-1] = 1'b0;
                else
                    res[N-1] = sign_b;
            end
        end

        c = res;
    end

endmodule