module fixed_point_adder #(
    parameter integer Q = 8,     // Number of fractional bits (precision)
    parameter integer N = 16     // Total number of bits including sign bit
)(
    input  wire [N-1:0] a,       // Fixed-point input operand A (two's complement)
    input  wire [N-1:0] b,       // Fixed-point input operand B (two's complement)
    output reg  [N-1:0] c        // Fixed-point addition result (two's complement)
);

    // Internal register to store result
    reg [N-1:0] res;

    // Internal signals for sign and magnitude extraction
    reg sign_a;
    reg sign_b;

    reg [N-2:0] mag_a;
    reg [N-2:0] mag_b;

    reg sign_res;
    reg [N-2:0] mag_res;

    // Widened register for addition result to detect overflow
    reg [N:0] sum_mag;

    // Maximum magnitude for saturation (all ones in N-1 bits)
    localparam [N-2:0] MAX_MAG = { (N-1){1'b1} };

    always @(*) begin
        // Extract sign bits
        sign_a = a[N-1];
        sign_b = b[N-1];

        // Convert two's complement inputs to magnitude (sign-magnitude)
        // For negative numbers: magnitude = two's complement of lower bits
        if (sign_a)
            mag_a = (~a[N-2:0]) + 1'b1;
        else
            mag_a = a[N-2:0];

        if (sign_b)
            mag_b = (~b[N-2:0]) + 1'b1;
        else
            mag_b = b[N-2:0];

        if (sign_a == sign_b) begin
            // Same sign: add magnitudes
            sum_mag = {1'b0, mag_a} + {1'b0, mag_b}; // one extra bit for overflow

            // Saturation check
            if (sum_mag[N-1]) begin
                // Overflow in magnitude addition
                mag_res = MAX_MAG;
            end else begin
                mag_res = sum_mag[N-2:0];
            end

            sign_res = sign_a;
        end else begin
            // Different signs: subtract smaller magnitude from larger magnitude
            if (mag_a > mag_b) begin
                mag_res = mag_a - mag_b;
                sign_res = sign_a;
            end else if (mag_b > mag_a) begin
                mag_res = mag_b - mag_a;
                sign_res = sign_b;
            end else begin
                // Equal magnitudes => result zero
                mag_res = { (N-1){1'b0} };
                sign_res = 1'b0; // positive zero
            end
        end

        // Convert sign-magnitude result back to two's complement
        if (sign_res) begin
            // Negative number: two's complement of magnitude
            res = {1'b1, (~mag_res + 1'b1)};
        end else begin
            // Positive number: sign bit 0 and magnitude as is
            res = {1'b0, mag_res};
        end

        // Assign result to output
        c = res;
    end

endmodule