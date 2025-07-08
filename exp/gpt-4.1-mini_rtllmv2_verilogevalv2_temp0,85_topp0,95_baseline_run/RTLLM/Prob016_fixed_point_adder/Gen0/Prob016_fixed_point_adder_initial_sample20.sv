module fixed_point_adder #(
    parameter Q = 8,            // Number of fractional bits
    parameter N = 16            // Total bits (integer + fractional + sign)
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

    // Absolute values (magnitude) of a and b: mask out the sign bit
    wire [N-2:0] a_abs = a[N-2:0];
    wire [N-2:0] b_abs = b[N-2:0];

    // Variables for addition and subtraction results
    reg [N-1:0] sum;     // sum of absolute values + sign bit
    reg [N-1:0] diff;    // difference of absolute values + sign bit

    // To compare magnitudes, treat a_abs and b_abs as unsigned numbers
    // Note: magnitude is N-1 bits

    always @(*) begin
        if (a_sign == b_sign) begin
            // Same sign => add absolute values
            // Sum width: (N-1 bits) + 1 = N bits to avoid overflow in magnitude addition
            // We add magnitudes, then assign sign bit

            // Add magnitudes
            // sum_magnitude can be N bits
            wire [N-1:0] sum_magnitude = {1'b0, a_abs} + {1'b0, b_abs};

            // Assign sign bit
            res[N-1] = a_sign;

            // Assign magnitude bits
            // If overflow occurs in magnitude addition (sum_magnitude[N-1] == 1),
            // it means result cannot fit in N-1 bits, but since fixed width,
            // just truncate the MSB (wrap-around), no saturation logic specified.
            res[N-2:0] = sum_magnitude[N-2:0];

        end else begin
            // Different sign => subtract smaller magnitude from larger
            // Determine which magnitude is larger
            if (a_abs > b_abs) begin
                // res = a_abs - b_abs, sign = a_sign (sign bit of 'a')

                wire [N-1:0] diff_magnitude = {1'b0, a_abs} - {1'b0, b_abs};

                // If diff is zero, set sign bit to 0 (positive zero)
                if (diff_magnitude[N-2:0] == 0) begin
                    res[N-1] = 1'b0;
                end else begin
                    res[N-1] = a_sign;
                end

                res[N-2:0] = diff_magnitude[N-2:0];

            end else if (b_abs > a_abs) begin
                // res = b_abs - a_abs, sign = b_sign

                wire [N-1:0] diff_magnitude = {1'b0, b_abs} - {1'b0, a_abs};

                // If diff is zero, sign bit zero
                if (diff_magnitude[N-2:0] == 0) begin
                    res[N-1] = 1'b0;
                end else begin
                    res[N-1] = b_sign;
                end

                res[N-2:0] = diff_magnitude[N-2:0];

            end else begin
                // a_abs == b_abs, result is zero with positive sign
                res = {1'b0, {(N-1){1'b0}}};
            end
        end

        c = res;
    end

endmodule