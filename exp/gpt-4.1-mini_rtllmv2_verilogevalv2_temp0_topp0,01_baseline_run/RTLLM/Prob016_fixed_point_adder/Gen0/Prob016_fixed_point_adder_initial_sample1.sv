module fixed_point_adder #(parameter Q = 8, parameter N = 16) (
    input  wire [N-1:0] a,
    input  wire [N-1:0] b,
    output wire [N-1:0] c
);

    // Internal register to hold the result
    reg [N-1:0] res;

    // Function to compute absolute value of two's complement number
    function [N-1:0] abs_val;
        input [N-1:0] val;
        begin
            if (val[N-1] == 1'b0)
                abs_val = val;
            else
                abs_val = (~val) + 1'b1;
        end
    endfunction

    // Internal signals for absolute values
    wire [N-1:0] abs_a = abs_val(a);
    wire [N-1:0] abs_b = abs_val(b);

    // Compare absolute values
    wire a_greater = (abs_a > abs_b);

    always @(*) begin
        if (a[N-1] == b[N-1]) begin
            // Same sign: add absolute values
            // sum_abs can be N+1 bits to detect overflow, but we truncate to N bits
            // The sign bit is same as inputs
            reg [N:0] sum_abs;
            sum_abs = abs_a + abs_b;
            // Assign result with sign bit same as inputs
            // If overflow occurs, it will wrap around naturally in two's complement
            res = {a[N-1], sum_abs[N-2:0]};
        end else begin
            // Different signs: subtract smaller abs from larger abs
            reg [N-1:0] diff_abs;
            if (a_greater) begin
                diff_abs = abs_a - abs_b;
                // sign bit 0 (positive)
                res = diff_abs;
            end else begin
                diff_abs = abs_b - abs_a;
                // sign bit 1 if diff_abs != 0, else 0
                if (diff_abs == 0)
                    res = {1'b0, diff_abs[N-2:0]};
                else
                    res = {1'b1, diff_abs[N-2:0]};
            end
        end
    end

    assign c = res;

endmodule