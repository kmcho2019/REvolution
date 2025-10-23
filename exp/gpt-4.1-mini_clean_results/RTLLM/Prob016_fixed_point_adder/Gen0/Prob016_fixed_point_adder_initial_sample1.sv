module fixed_point_adder #(parameter Q = 8, parameter N = 16)(
    input  wire [N-1:0] a,
    input  wire [N-1:0] b,
    output reg  [N-1:0] c
);

    // Internal register to hold the result magnitude and sign
    reg [N-2:0] a_abs, b_abs;
    reg [N-1:0] res;
    reg sign_a, sign_b;
    reg sign_res;

    // Function to compute absolute value of two's complement number
    function [N-2:0] abs_val;
        input [N-1:0] val;
        begin
            if(val[N-1] == 1'b1)
                abs_val = (~val[N-2:0]) + 1'b1;
            else
                abs_val = val[N-2:0];
        end
    endfunction

    always @(*) begin
        sign_a = a[N-1];
        sign_b = b[N-1];
        a_abs = abs_val(a);
        b_abs = abs_val(b);

        if(sign_a == sign_b) begin
            // Same sign: add absolute values
            // Add with one extra bit to check for overflow but result truncated to N-1 bits
            // sum_abs may be up to N bits
            reg [N:0] sum_abs_ext;
            sum_abs_ext = {1'b0, a_abs} + {1'b0, b_abs};
            // Handle overflow: if sum exceeds N-1 bits, saturate
            if(sum_abs_ext[N] == 1'b1) begin
                // Saturate to max magnitude (all 1s)
                res[N-2:0] = { (N-1){1'b1} };
            end else begin
                res[N-2:0] = sum_abs_ext[N-1:0];
            end
            res[N-1] = sign_a; // Sign stays the same
        end else begin
            // Different signs: subtract smaller abs from larger abs
            if(a_abs >= b_abs) begin
                res[N-2:0] = a_abs - b_abs;
                res[N-1] = sign_a; // sign of bigger magnitude operand a
                // If result magnitude zero, force positive zero sign bit
                if(res[N-2:0] == 0)
                    res[N-1] = 1'b0;
            end else begin
                res[N-2:0] = b_abs - a_abs;
                res[N-1] = sign_b; // sign of bigger magnitude operand b
                if(res[N-2:0] == 0)
                    res[N-1] = 1'b0;
            end
        end

        // Compose two's complement result from sign and magnitude
        // If sign=0 (positive), output is magnitude as is.
        // If sign=1 (negative), output is two's complement of magnitude.
        if(res[N-1] == 1'b0) begin
            c = {1'b0, res[N-2:0]};
        end else begin
            c = {1'b1, (~res[N-2:0]) + 1'b1};
        end
    end

endmodule