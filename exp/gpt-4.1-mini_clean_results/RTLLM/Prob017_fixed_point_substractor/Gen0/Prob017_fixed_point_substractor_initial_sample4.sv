module fixed_point_subtractor #(parameter Q = 8, parameter N = 16) (
    input  wire [N-1:0] a,
    input  wire [N-1:0] b,
    output reg  [N-1:0] c
);

    reg [N-1:0] res;
    wire a_sign = a[N-1];
    wire b_sign = b[N-1];

    // Function to compute absolute value of signed fixed-point number
    function [N-1:0] abs_val;
        input [N-1:0] val;
        begin
            if (val[N-1] == 1'b1)
                abs_val = (~val + 1'b1);
            else
                abs_val = val;
        end
    endfunction

    // Compare absolute values a_abs and b_abs
    // Returns 1 if a_abs >= b_abs else 0
    function cmp_abs_ge;
        input [N-1:0] a_abs;
        input [N-1:0] b_abs;
        begin
            // unsigned comparison since a_abs and b_abs are positive magnitude
            cmp_abs_ge = (a_abs >= b_abs);
        end
    endfunction

    reg [N-1:0] a_abs, b_abs;
    reg [N-1:0] sum_abs;
    reg [N-1:0] diff_abs;
    reg sign_res;
    reg zero_result;

    always @* begin
        a_abs = abs_val(a);
        b_abs = abs_val(b);

        if (a_sign == b_sign) begin
            // Same sign: subtract b from a
            res = a - b;
            sign_res = res[N-1];
        end else begin
            // Different sign: add absolute values and assign sign accordingly
            sum_abs = a_abs + b_abs;

            // Determine which absolute value is larger for sign
            if (cmp_abs_ge(a_abs, b_abs)) begin
                sign_res = a_sign;
                res = sign_res ? (~sum_abs + 1'b1) : sum_abs; // apply sign to sum_abs
            end else begin
                sign_res = b_sign;
                res = sign_res ? (~sum_abs + 1'b1) : sum_abs;
            end
        end

        zero_result = (res == {N{1'b0}});
        if (zero_result) begin
            // zero result: force sign bit to zero
            res[N-1] = 1'b0;
        end

        c = res;
    end

endmodule