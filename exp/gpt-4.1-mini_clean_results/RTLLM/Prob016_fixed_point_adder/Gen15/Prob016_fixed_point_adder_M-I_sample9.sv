module fixed_point_adder #(
    parameter integer N = 16,       // Total number of bits (including sign)
    parameter integer Q = 8         // Number of fractional bits (precision)
)(
    input  wire [N-1:0] a,          // Fixed-point input operand a (two's complement)
    input  wire [N-1:0] b,          // Fixed-point input operand b (two's complement)
    output reg  [N-1:0] c           // Fixed-point output result
);

    // Extract sign bits
    wire a_sign = a[N-1];
    wire b_sign = b[N-1];

    // Compute magnitudes (absolute values)
    wire [N-1:0] a_mag = a_sign ? (~a + 1'b1) : a;
    wire [N-1:0] b_mag = b_sign ? (~b + 1'b1) : b;

    // Determine if signs are equal
    wire same_sign = (a_sign == b_sign);

    // Magnitude comparison
    wire a_greater_eq = (a_mag >= b_mag);

    // Intermediate variables
    reg [N:0] res_mag;   // one extra bit to hold potential overflow from addition
    reg res_sign;

    always @(*) begin
        if (same_sign) begin
            // Same signs: add magnitudes
            res_mag = {1'b0, a_mag} + {1'b0, b_mag};
            res_sign = a_sign;
        end else begin
            // Different signs: subtract smaller magnitude from larger
            if (a_greater_eq) begin
                res_mag = {1'b0, a_mag} - {1'b0, b_mag};
                res_sign = a_sign;
            end else begin
                res_mag = {1'b0, b_mag} - {1'b0, a_mag};
                res_sign = b_sign;
            end
        end

        // If result is zero, force sign to positive
        if (res_mag[N-1:0] == {N{1'b0}})
            res_sign = 1'b0;

        // Convert magnitude and sign back to two's complement
        if (res_sign)
            c = ~res_mag[N-1:0] + 1'b1;  // negative result
        else
            c = res_mag[N-1:0];          // positive result
    end

endmodule