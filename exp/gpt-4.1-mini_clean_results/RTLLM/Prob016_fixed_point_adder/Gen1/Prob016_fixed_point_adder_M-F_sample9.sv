module fixed_point_adder #(parameter N = 16, parameter Q = 8) (
    input  wire [N-1:0] a,
    input  wire [N-1:0] b,
    output reg  [N-1:0] c
);

    // Internal register for result
    reg [N-1:0] res;

    // Extract sign bits
    wire a_sign = a[N-1];
    wire b_sign = b[N-1];

    // Compute absolute values (magnitudes) of a and b
    // If negative, take two's complement to get magnitude
    wire [N-2:0] a_mag = a_sign ? (~a[N-2:0] + 1'b1) : a[N-2:0];
    wire [N-2:0] b_mag = b_sign ? (~b[N-2:0] + 1'b1) : b[N-2:0];

    // Sum and difference of magnitudes with one extra bit to handle carry/borrow
    wire [N-1:0] add_mag = {1'b0, a_mag} + {1'b0, b_mag};       // Sum of magnitudes
    wire [N-1:0] sub_mag_a_b = {1'b0, a_mag} - {1'b0, b_mag};  // a_mag - b_mag
    wire [N-1:0] sub_mag_b_a = {1'b0, b_mag} - {1'b0, a_mag};  // b_mag - a_mag

    always @(*) begin
        if (a_sign == b_sign) begin
            // Same sign: add magnitudes, sign stays the same
            // Discard overflow carry (add_mag[N-1]) if any
            res[N-2:0] = add_mag[N-2:0];
            res[N-1] = a_sign;
        end else begin
            // Different signs: subtract smaller magnitude from larger
            if (a_mag == b_mag) begin
                // Magnitudes equal, result is zero
                res = {N{1'b0}};
            end else if (a_mag > b_mag) begin
                // a magnitude larger: result = a_mag - b_mag
                res[N-2:0] = sub_mag_a_b[N-2:0];
                // Result sign is sign of a (operand with larger magnitude)
                res[N-1] = a_sign;
            end else begin
                // b magnitude larger: result = b_mag - a_mag
                res[N-2:0] = sub_mag_b_a[N-2:0];
                // Result sign is sign of b (operand with larger magnitude)
                res[N-1] = b_sign;
            end
        end
    end

    // Assign output
    always @(*) begin
        c = res;
    end

endmodule