module fixed_point_adder #(parameter Q = 8, parameter N = 16)(
    input  wire [N-1:0] a,
    input  wire [N-1:0] b,
    output reg  [N-1:0] c
);

    // Internal register to hold the result
    reg [N-1:0] res;

    // Function to get absolute value of two's complement number
    function [N-1:0] abs_val;
        input [N-1:0] x;
        begin
            // If sign bit is 1, two's complement negation
            if (x[N-1] == 1'b1)
                abs_val = (~x) + 1'b1;
            else
                abs_val = x;
        end
    endfunction

    // Function to compare absolute values (returns 1 if a_abs > b_abs)
    function is_a_abs_greater;
        input [N-1:0] a_abs;
        input [N-1:0] b_abs;
        begin
            if (a_abs > b_abs)
                is_a_abs_greater = 1'b1;
            else
                is_a_abs_greater = 1'b0;
        end
    endfunction

    always @* begin
        // Extract signs
        wire a_sign = a[N-1];
        wire b_sign = b[N-1];

        // Compute absolute values
        wire [N-1:0] a_abs = abs_val(a);
        wire [N-1:0] b_abs = abs_val(b);

        // Initialize
        res = {N{1'b0}};

        if (a_sign == b_sign) begin
            // Same sign: add absolute values
            reg [N:0] sum; // One extra bit for carry
            sum = {1'b0, a_abs} + {1'b0, b_abs};
            // Result sign matches inputs
            // Truncate to N bits, ignoring carry out (overflow handled by bit width)
            res = {a_sign, sum[N-2:0]};
        end else begin
            // Different signs: subtract smaller absolute value from larger absolute value
            if (is_a_abs_greater(a_abs, b_abs)) begin
                // a_abs > b_abs: result = a_abs - b_abs, sign = a_sign (which is 0 here)
                reg [N-1:0] diff;
                diff = a_abs - b_abs;
                // Since a_sign != b_sign, a_sign is 0 means positive result
                res = {1'b0, diff[N-2:0]};
            end else if (is_a_abs_greater(b_abs, a_abs)) begin
                // b_abs > a_abs: result = b_abs - a_abs, sign = b_sign (which is 0 or 1)
                reg [N-1:0] diff;
                diff = b_abs - a_abs;
                // If diff is zero, sign bit should be 0 (positive zero)
                if (diff == 0)
                    res = {1'b0, {(N-1){1'b0}}};
                else
                    res = {b_sign, diff[N-2:0]};
            end else begin
                // a_abs == b_abs => result zero with positive sign
                res = {1'b0, {(N-1){1'b0}}};
            end
        end

        c = res;
    end

endmodule