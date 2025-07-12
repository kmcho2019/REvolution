module fixed_point_adder #(parameter Q = 8, parameter N = 16) (
    input  wire [N-1:0] a,
    input  wire [N-1:0] b,
    output reg  [N-1:0] c
);
    reg [N-1:0] res;

    // Function to get absolute value of a signed N-bit number
    function [N-1:0] abs_val;
        input [N-1:0] in;
        begin
            if (in[N-1] == 1'b1)
                abs_val = (~in) + 1'b1; // two's complement negation
            else
                abs_val = in;
        end
    endfunction

    // Function to convert signed magnitude (abs + sign) back to two's complement
    function [N-1:0] to_twos_complement;
        input [N-1:0] magnitude;
        input sign;
        begin
            if (sign == 1'b1)
                to_twos_complement = (~magnitude) + 1'b1;
            else
                to_twos_complement = magnitude;
        end
    endfunction

    reg a_sign, b_sign;
    reg [N-1:0] a_abs, b_abs;
    reg [N:0] sum_abs; // one extra bit for carry out
    reg [N-1:0] diff_abs;
    reg sign_res;

    always @* begin
        a_sign = a[N-1];
        b_sign = b[N-1];

        a_abs = abs_val(a);
        b_abs = abs_val(b);

        if (a_sign == b_sign) begin
            // Same sign: add absolute values
            sum_abs = a_abs + b_abs;
            // Truncate sum_abs to N bits, discard overflow bit if any
            // To handle overflow conservatively, result sign remains a_sign
            res = sum_abs[N-1:0];
            sign_res = a_sign;
        end else begin
            // Different signs: subtract smaller absolute from larger absolute
            if (a_abs >= b_abs) begin
                diff_abs = a_abs - b_abs;
                res = diff_abs;
                sign_res = a_sign; // sign of the operand with larger abs value (a)
            end else begin
                diff_abs = b_abs - a_abs;
                res = diff_abs;
                sign_res = b_sign; // sign of the operand with larger abs value (b)
            end
        end

        // Convert sign + magnitude result back to two's complement
        c = to_twos_complement(res, sign_res);
    end
endmodule