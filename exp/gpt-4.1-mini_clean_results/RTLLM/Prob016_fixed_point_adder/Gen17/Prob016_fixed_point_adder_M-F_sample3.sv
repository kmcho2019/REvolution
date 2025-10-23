module fixed_point_adder #(
    parameter integer Q = 8,    // Number of fractional bits (precision)
    parameter integer N = 16    // Total number of bits including sign bit
)(
    input  wire [N-1:0] a,      // Fixed-point input operand A (two's complement)
    input  wire [N-1:0] b,      // Fixed-point input operand B (two's complement)
    output reg  [N-1:0] c       // Fixed-point addition result (two's complement)
);

    // Internal signals
    reg sign_a, sign_b;                     // Sign bits of inputs
    reg [N-2:0] mag_a;                      // Magnitude of a (N-1 bits)
    reg [N-2:0] mag_b;                      // Magnitude of b (N-1 bits)
    reg [N-1:0] sum_mag;                    // Sum magnitude (N bits, for overflow detection)
    reg [N-2:0] diff_mag;                   // Difference magnitude (N-1 bits)
    reg sign_res;                          // Sign bit of the result
    reg [N-2:0] mag_res;                   // Magnitude of the result (N-1 bits)

    // Constants for saturation
    localparam [N-1:0] MAX_VAL = {1'b0, {(N-1){1'b1}}};  // Max positive: 0 followed by ones
    localparam [N-1:0] MIN_VAL = {1'b1, {(N-1){1'b0}}};  // Min negative: 1 followed by zeros

    // Inline absolute value extraction (magnitude) for input operands
    // If sign bit is 0, magnitude = lower bits as is
    // If sign bit is 1, magnitude = two's complement of input without sign bit
    always @(*) begin
        sign_a = a[N-1];
        sign_b = b[N-1];

        if (sign_a == 1'b0)
            mag_a = a[N-2:0];
        else
            mag_a = (~a[N-2:0]) + 1'b1;

        if (sign_b == 1'b0)
            mag_b = b[N-2:0];
        else
            mag_b = (~b[N-2:0]) + 1'b1;
    end

    always @(*) begin
        // Default assignments
        sign_res = 1'b0;
        mag_res = {(N-1){1'b0}};
        sum_mag = {(N){1'b0}};
        diff_mag = {(N-1){1'b0}};

        if (sign_a == sign_b) begin
            // Same sign: add magnitudes with possible overflow (N bits wide)
            sum_mag = {1'b0, mag_a} + {1'b0, mag_b};

            if (sum_mag[N-1] == 1'b1) begin
                // Overflow occurred, saturate accordingly
                if (sign_a == 1'b0) begin
                    // Positive overflow saturate to MAX_VAL
                    c = MAX_VAL;
                end else begin
                    // Negative overflow saturate to MIN_VAL
                    c = MIN_VAL;
                end
            end else begin
                // No overflow, assign result
                sign_res = sign_a;
                mag_res = sum_mag[N-2:0];
                c = {sign_res, mag_res};
            end
        end else begin
            // Different signs: subtract smaller magnitude from larger
            if (mag_a > mag_b) begin
                diff_mag = mag_a - mag_b;
                sign_res = sign_a;
                if (diff_mag == 0) begin
                    // Zero result => positive zero
                    c = {1'b0, {(N-1){1'b0}}};
                end else begin
                    c = {sign_res, diff_mag};
                end
            end else if (mag_b > mag_a) begin
                diff_mag = mag_b - mag_a;
                sign_res = sign_b;
                if (diff_mag == 0) begin
                    // Zero result => positive zero
                    c = {1'b0, {(N-1){1'b0}}};
                end else begin
                    c = {sign_res, diff_mag};
                end
            end else begin
                // Equal magnitude but opposite signs => zero result
                c = {1'b0, {(N-1){1'b0}}};
            end
        end
    end

endmodule