module fixed_point_adder #(parameter Q = 8, parameter N = 16) (
    input  wire [N-1:0] a,
    input  wire [N-1:0] b,
    output reg  [N-1:0] c
);

    // Function to get absolute value of signed number in two's complement
    function [N-1:0] abs_val;
        input [N-1:0] val;
        begin
            if (val[N-1] == 1'b1) // negative number
                abs_val = (~val) + 1'b1;
            else
                abs_val = val;
        end
    endfunction

    // Function to convert sign+magnitude to two's complement number
    function [N-1:0] to_twos_complement;
        input [N-2:0] magnitude;  // magnitude bits (excluding sign)
        input          sign;      // sign bit: 0=pos,1=neg
        reg   [N-1:0]  result;
        begin
            if (sign == 1'b0) begin
                // positive number
                result = {1'b0, magnitude};
            end else begin
                // negative number: two's complement of magnitude
                result = ~{1'b0, magnitude} + 1'b1;
            end
            to_twos_complement = result;
        end
    endfunction

    reg sign_a, sign_b;
    reg [N-2:0] abs_a_mag, abs_b_mag;
    reg [N-1:0] abs_a, abs_b;  // absolute values (full width)
    reg [N-1:0] sum_mag;       // sum or diff magnitude with possible overflow bit
    reg        res_sign;
    reg [N-2:0] res_mag;

    always @* begin
        sign_a = a[N-1];
        sign_b = b[N-1];
        abs_a = abs_val(a);
        abs_b = abs_val(b);

        // Extract magnitude without sign bit
        abs_a_mag = abs_a[N-2:0];
        abs_b_mag = abs_b[N-2:0];

        if (sign_a == sign_b) begin
            // Same sign: add magnitudes
            sum_mag = abs_a + abs_b; // N bits, can overflow carry into MSB

            // Result sign same as inputs
            res_sign = sign_a;

            // Since sum_mag is N bits and magnitude is N-1 bits, discard carry out (overflow)
            // Clip magnitude to N-1 bits (possible saturation not implemented)
            res_mag = sum_mag[N-2:0];
        end else begin
            // Different sign: subtract smaller magnitude from larger magnitude
            if (abs_a >= abs_b) begin
                sum_mag = abs_a - abs_b;
                res_sign = sign_a;
            end else begin
                sum_mag = abs_b - abs_a;
                res_sign = sign_b;
            end
            res_mag = sum_mag[N-2:0];
        end

        // If magnitude is zero, force sign to 0 (positive zero)
        if (res_mag == 0)
            res_sign = 1'b0;

        // Compose result from sign and magnitude
        c = to_twos_complement(res_mag, res_sign);
    end

endmodule