module fixed_point_adder #(
    parameter integer Q = 8,           // Number of fractional bits
    parameter integer N = 16           // Total bits including sign bit
)(
    input  wire [N-1:0] a,             // Fixed-point input operand a
    input  wire [N-1:0] b,             // Fixed-point input operand b
    output reg  [N-1:0] c              // Fixed-point output result
);

    // Internal signals
    wire a_sign = a[N-1];              // Sign bit of a
    wire b_sign = b[N-1];              // Sign bit of b

    // Compute magnitude of a: if sign=1, magnitude = two's complement negation, else a as is
    wire [N-1:0] a_mag = a_sign ? (~a + 1'b1) : a;

    // Compute magnitude of b similarly
    wire [N-1:0] b_mag = b_sign ? (~b + 1'b1) : b;

    // Result sign and magnitude wires
    reg res_sign;
    reg [N-1:0] res_mag;

    // Temporary for addition/subtraction with one extra bit to detect carry/borrow
    wire [N:0] sum_mag = a_mag + b_mag;         // sum magnitude (N+1 bits)
    wire [N:0] diff_mag_ab = a_mag - b_mag;     // a_mag - b_mag (may be negative)
    wire [N:0] diff_mag_ba = b_mag - a_mag;     // b_mag - a_mag

    always @* begin
        if (a_sign == b_sign) begin
            // Same sign: add magnitudes
            if (sum_mag[N]) begin
                // Carry out means magnitude overflow beyond N bits; saturate to max magnitude
                res_mag = {1'b0, {(N-1){1'b1}}}; // max magnitude with sign bit zero
            end else begin
                res_mag = sum_mag[N-1:0];
            end
            res_sign = a_sign; // same sign result
        end else begin
            // Different signs: subtract smaller magnitude from larger
            if (a_mag >= b_mag) begin
                res_mag = diff_mag_ab[N-1:0]; // positive result magnitude
                res_sign = 1'b0; // result is positive if a >= b in magnitude
                if (res_mag == 0)
                    res_sign = 1'b0; // zero is positive by convention
                else
                    res_sign = a_sign ? 1'b1 : 1'b0; // sign of operand with larger magnitude
            end else begin
                res_mag = diff_mag_ba[N-1:0];
                res_sign = 1'b0; // default positive
                if (res_mag == 0)
                    res_sign = 1'b0;
                else
                    res_sign = b_sign ? 1'b1 : 1'b0;
            end
        end
    end

    // Convert magnitude and sign back to two's complement fixed-point number
    always @* begin
        if (res_sign == 1'b0) begin
            // positive number: direct magnitude
            res = res_mag;
        end else begin
            // negative number: two's complement of magnitude
            res = ~res_mag + 1'b1;
        end
    end

    reg [N-1:0] res;

    // Assign output
    always @* begin
        c = res;
    end

endmodule