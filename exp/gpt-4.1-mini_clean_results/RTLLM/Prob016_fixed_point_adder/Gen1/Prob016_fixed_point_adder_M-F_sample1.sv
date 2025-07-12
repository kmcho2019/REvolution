module fixed_point_adder #(parameter Q = 8, parameter N = 16) (
    input  wire [N-1:0] a,
    input  wire [N-1:0] b,
    output reg  [N-1:0] c
);

    reg [N-1:0] res;
    reg a_sign, b_sign;
    reg [N-1:0] abs_a;
    reg [N-1:0] abs_b;

    // Function to get absolute value of fixed-point number (N-bit two's complement)
    function [N-1:0] abs_val;
        input [N-1:0] val;
        begin
            if (val[N-1] == 1'b1)
                abs_val = (~val) + 1'b1;
            else
                abs_val = val;
        end
    endfunction

    // Function to compare absolute values: returns 1 if abs(a) >= abs(b)
    function abs_ge;
        input [N-1:0] val_a, val_b;
        begin
            abs_ge = (abs_val(val_a) >= abs_val(val_b));
        end
    endfunction

    always @* begin
        // Assign sign bits
        a_sign = a[N-1];
        b_sign = b[N-1];

        abs_a = abs_val(a);
        abs_b = abs_val(b);

        if (a_sign == b_sign) begin
            // Same sign: add absolute values
            res = abs_a + abs_b;

            // If sum overflows MSB, two's complement wrap-around will naturally occur

            // Reapply sign by converting absolute sum to two's complement if negative
            if (a_sign == 1'b1)
                c = (~res) + 1'b1; // negative result
            else
                c = res;            // positive result
        end else begin
            // Different signs: subtract smaller abs from larger abs
            if (abs_ge(a, b)) begin
                // abs(a) >= abs(b), result sign is a_sign
                res = abs_a - abs_b;

                if (res == 0)
                    c = {N{1'b0}}; // zero
                else if (a_sign == 1'b0)
                    c = res;       // positive result
                else
                    c = (~res) + 1'b1; // negative result
            end else begin
                // abs(b) > abs(a), result sign is b_sign
                res = abs_b - abs_a;

                if (res == 0)
                    c = {N{1'b0}}; // zero
                else if (b_sign == 1'b0)
                    c = res;       // positive result
                else
                    c = (~res) + 1'b1; // negative result
            end
        end
    end

endmodule