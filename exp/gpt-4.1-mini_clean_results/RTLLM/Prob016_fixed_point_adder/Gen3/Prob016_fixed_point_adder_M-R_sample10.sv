module fixed_point_adder #(
    parameter integer Q = 8,    // Number of fractional bits
    parameter integer N = 16    // Total number of bits (integer + fractional + sign)
)(
    input  wire [N-1:0] a,
    input  wire [N-1:0] b,
    output reg  [N-1:0] c
);

    // Internal signed registers for computation
    reg signed [N-1:0] a_s;
    reg signed [N-1:0] b_s;
    reg [N-1:0] a_abs;
    reg [N-1:0] b_abs;
    reg signed [N-1:0] res;

    // Compute fixed-point addition/subtraction combinationally
    always @* begin
        // Interpret inputs as signed fixed-point numbers (two's complement)
        a_s = $signed(a);
        b_s = $signed(b);

        // Compute absolute values
        a_abs = a_s[N-1] ? (~a_s + 1'b1) : a_s;
        b_abs = b_s[N-1] ? (~b_s + 1'b1) : b_s;

        if (a_s[N-1] == b_s[N-1]) begin
            // Same sign: add absolute values with sign preservation
            res = a_s + b_s;
        end else begin
            // Different signs: subtract smaller absolute value from larger
            if (a_abs >= b_abs) begin
                // Result sign matches a_s's sign (which is different from b_s)
                res = $signed({1'b0, a_abs}) - $signed({1'b0, b_abs});
                if (res == 0)
                    res = 0;
                else if (a_s[N-1])
                    res = -res; // Negative result
            end else begin
                res = $signed({1'b0, b_abs}) - $signed({1'b0, a_abs});
                if (res == 0)
                    res = 0;
                else if (b_s[N-1])
                    res = -res; // Negative result
            end
        end

        c = res[N-1:0];
    end

endmodule