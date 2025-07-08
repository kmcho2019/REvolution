module fixed_point_adder #(
    parameter Q = 8,        // Number of fractional bits
    parameter N = 16        // Total bits (integer + fractional + sign)
)(
    input  wire [N-1:0] a,
    input  wire [N-1:0] b,
    output reg  [N-1:0] c
);

    // Internal register to hold the result
    reg [N-1:0] res;

    // Extract sign bits
    wire a_sign = a[N-1];
    wire b_sign = b[N-1];

    // Function to get absolute value of fixed-point number
    function [N-1:0] abs_val;
        input [N-1:0] val;
        begin
            if(val[N-1] == 1'b0) // positive
                abs_val = val;
            else
                abs_val = (~val + 1'b1);
        end
    endfunction

    // Internal absolute values
    reg [N-1:0] a_abs;
    reg [N-1:0] b_abs;

    // Internal result magnitude and sign
    reg [N-1:0] mag_res;
    reg        res_sign;

    integer i;

    always @(*) begin
        a_abs = abs_val(a);
        b_abs = abs_val(b);

        if (a_sign == b_sign) begin
            // Same sign: add absolute values
            mag_res = a_abs + b_abs;

            // Check overflow: if result exceeds max positive value, it wraps as per two's complement
            // Here, we just keep lower N bits, but sign bit is same as inputs
            res_sign = a_sign;

            // If overflow bit (bit N) occurred, it will wrap around naturally
            // So no explicit saturation, just take N LSBs

        end else begin
            // Different signs: subtract smaller abs from larger abs
            if (a_abs >= b_abs) begin
                mag_res = a_abs - b_abs;
                res_sign = a_sign; // sign of larger absolute value operand
            end else begin
                mag_res = b_abs - a_abs;
                res_sign = b_sign; // sign of larger absolute value operand
            end
        end

        // If magnitude is zero, force sign to 0 (positive zero)
        if (mag_res == {N{1'b0}}) begin
            res_sign = 1'b0;
        end

        // Reapply sign: if positive, output magnitude as is, else output two's complement
        if (res_sign == 1'b0) begin
            // positive number
            res = mag_res;
        end else begin
            // negative number: take two's complement
            res = ~mag_res + 1'b1;
        end

        c = res;
    end

endmodule