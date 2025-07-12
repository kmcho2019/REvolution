module fixed_point_adder #(
    parameter integer Q = 8,            // Number of fractional bits
    parameter integer N = 16            // Total bits (including sign)
)(
    input  wire [N-1:0] a,              // Fixed-point input operand a
    input  wire [N-1:0] b,              // Fixed-point input operand b
    output reg  [N-1:0] c               // Fixed-point output result c
);

    // Internal registers
    reg [N-2:0] a_abs;   // Absolute value of a (without sign bit)
    reg [N-2:0] b_abs;   // Absolute value of b (without sign bit)
    reg [N-2:0] res_abs; // Absolute value result (without sign)
    reg sign_res;        // Sign bit of result

    // Compare absolute values function
    function [0:0] abs_gte;
        input [N-2:0] x;
        input [N-2:0] y;
        begin
            abs_gte = (x >= y);
        end
    endfunction

    always @(*) begin
        // Extract absolute values by clearing sign bit and taking two's complement if negative
        if (a[N-1] == 1'b0)
            a_abs = a[N-2:0];
        else
            a_abs = (~a[N-2:0]) + 1'b1;

        if (b[N-1] == 1'b0)
            b_abs = b[N-2:0];
        else
            b_abs = (~b[N-2:0]) + 1'b1;

        if (a[N-1] == b[N-1]) begin
            // Same sign: add absolute values
            {sign_res, res_abs} = {1'b0, a_abs} + {1'b0, b_abs};
            sign_res = a[N-1]; // sign stays same as inputs
        end else begin
            // Different sign: subtract smaller abs from larger abs
            if (abs_gte(a_abs, b_abs)) begin
                res_abs = a_abs - b_abs;
                sign_res = (res_abs == 0) ? 1'b0 : a[N-1];
            end else begin
                res_abs = b_abs - a_abs;
                sign_res = (res_abs == 0) ? 1'b0 : b[N-1];
            end
        end

        // Compose result: sign bit plus absolute value (two's complement if negative)
        if (sign_res == 1'b0) begin
            c = {sign_res, res_abs};
        end else begin
            // Convert abs back to two's complement negative number
            c = {sign_res, (~res_abs + 1'b1)};
        end
    end

endmodule