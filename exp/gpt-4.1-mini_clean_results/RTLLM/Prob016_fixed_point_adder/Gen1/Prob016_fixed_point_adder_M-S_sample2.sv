module fixed_point_adder #(parameter Q = 8, parameter N = 16) (
    input  wire [N-1:0] a,
    input  wire [N-1:0] b,
    output reg  [N-1:0] c
);

    // Internal signals
    reg                 a_sign, b_sign, res_sign;
    reg  [N-2:0]        a_mag, b_mag, res_mag;
    reg  [N-1:0]        sum_mag;
    reg  [N-1:0]        diff_mag;
    integer             i;
    reg                 mag_zero;

    // Function to get absolute magnitude of two's complement number
    function [N-2:0] abs_mag(input [N-1:0] val);
        begin
            if (val[N-1] == 1'b0)
                abs_mag = val[N-2:0];
            else
                abs_mag = (~val + 1'b1)[N-2:0];
        end
    endfunction

    always @* begin
        a_sign = a[N-1];
        b_sign = b[N-1];
        a_mag  = abs_mag(a);
        b_mag  = abs_mag(b);

        if (a_sign == b_sign) begin
            // Same signs: add magnitudes
            sum_mag = {1'b0, a_mag} + {1'b0, b_mag}; // one extra bit for carry
            res_sign = a_sign;
            // Truncate to N-1 bits magnitude (drop carry out)
            res_mag = sum_mag[N-1:1];
        end else begin
            // Different signs: subtract smaller magnitude from larger
            if (a_mag >= b_mag) begin
                diff_mag = {1'b0, a_mag} - {1'b0, b_mag};
                res_sign = a_sign;
                res_mag = diff_mag[N-1:1];
            end else begin
                diff_mag = {1'b0, b_mag} - {1'b0, a_mag};
                res_sign = b_sign;
                res_mag = diff_mag[N-1:1];
            end
        end

        // Check if magnitude is zero
        mag_zero = 1'b1;
        for (i = 0; i < N-1; i = i + 1)
            if (res_mag[i]) mag_zero = 1'b0;

        // If zero magnitude, force positive sign
        if (mag_zero)
            res_sign = 1'b0;

        // Reconstruct two's complement fixed-point number
        if (res_sign == 1'b0) begin
            c = {1'b0, res_mag};
        end else begin
            c = (~{1'b0, res_mag} + 1'b1);
        end
    end

endmodule