module fixed_point_adder #(
    parameter integer Q = 8,       // Number of fractional bits (precision)
    parameter integer N = 16       // Total number of bits including sign
)(
    input  wire [N-1:0] a,         // Fixed-point input operand A (two's complement)
    input  wire [N-1:0] b,         // Fixed-point input operand B (two's complement)
    output reg  [N-1:0] c          // Fixed-point addition result (two's complement)
);

    // Internal registers
    reg signed [N-2:0] abs_a;      // Absolute value of a without sign bit
    reg signed [N-2:0] abs_b;      // Absolute value of b without sign bit
    reg [N-1:0] res;               // Result register (N bits)
    reg signed [N-1:0] a_signed;   // Signed version of a
    reg signed [N-1:0] b_signed;   // Signed version of b
    reg signed [N-1:0] tmp_res;    // Temporary signed result

    // Compute absolute value of N-1 bits magnitude (excluding sign)
    function [N-2:0] abs_val;
        input signed [N-1:0] val;
        begin
            if (val[N-1] == 1'b0)
                abs_val = val[N-2:0];
            else
                abs_val = (~val[N-2:0] + 1'b1);
        end
    endfunction

    // Compare absolute values
    function abs_gte;
        input [N-2:0] x;
        input [N-2:0] y;
        begin
            abs_gte = (x >= y);
        end
    endfunction

    always @(*) begin
        a_signed = $signed(a);
        b_signed = $signed(b);

        // Extract absolute values
        abs_a = abs_val(a_signed);
        abs_b = abs_val(b_signed);

        // If signs are equal: add absolute values and assign sign
        if (a[N-1] == b[N-1]) begin
            // Sum of absolute values
            tmp_res = {1'b0, abs_a} + {1'b0, abs_b};
            // Assign sign bit same as operands
            if (tmp_res[N-1]) begin
                // Overflow in magnitude addition, saturate max magnitude
                // Saturation not specified, so just wrap
                res = {a[N-1], tmp_res[N-2:0]};
            end else begin
                res = {a[N-1], tmp_res[N-2:0]};
            end
        end
        else begin
            // Signs differ: perform subtraction of smaller abs from larger abs
            if (abs_gte(abs_a, abs_b)) begin
                // result = abs_a - abs_b, sign = sign of a
                tmp_res = {1'b0, abs_a} - {1'b0, abs_b};
                if (tmp_res == 0) begin
                    // Zero result: sign = 0 (positive)
                    res = {1'b0, tmp_res[N-2:0]};
                end else begin
                    res = {a[N-1], tmp_res[N-2:0]};
                end
            end else begin
                // result = abs_b - abs_a, sign = sign of b
                tmp_res = {1'b0, abs_b} - {1'b0, abs_a};
                if (tmp_res == 0) begin
                    // Zero result: sign = 0 (positive)
                    res = {1'b0, tmp_res[N-2:0]};
                end else begin
                    res = {b[N-1], tmp_res[N-2:0]};
                end
            end
        end

        // Assign to output
        c = res;
    end

endmodule