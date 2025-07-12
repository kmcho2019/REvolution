module fixed_point_adder #(
    parameter integer N = 16,       // Total bits including sign bit
    parameter integer Q = 8         // Number of fractional bits
)(
    input  wire [N-1:0] a,          // Fixed-point input operand a (two's complement signed)
    input  wire [N-1:0] b,          // Fixed-point input operand b (two's complement signed)
    output reg  [N-1:0] c           // Fixed-point output result
);

    // Internal register for result (N bits)
    reg [N-1:0] res;

    // Extract sign bits
    wire a_sign = a[N-1];
    wire b_sign = b[N-1];

    // Extract absolute values (magnitudes)
    wire [N-2:0] a_mag = a_sign ? (~a[N-2:0] + 1'b1) : a[N-2:0];
    wire [N-2:0] b_mag = b_sign ? (~b[N-2:0] + 1'b1) : b[N-2:0];

    // Extended width for addition/subtraction to detect overflow
    localparam integer MAG_WIDTH = N-1;
    localparam integer EXT_WIDTH = MAG_WIDTH + 1;

    reg [EXT_WIDTH-1:0] mag_sum;
    reg [EXT_WIDTH-1:0] mag_diff;
    reg result_sign;
    reg zero_result;

    // Maximum magnitude allowed (2^(N-1)-1)
    localparam [MAG_WIDTH-1:0] MAX_MAG = {MAG_WIDTH{1'b1}};

    always @* begin
        if (a_sign == b_sign) begin
            // Same sign: add magnitudes
            mag_sum = {1'b0, a_mag} + {1'b0, b_mag};

            // Saturate magnitude if overflow (if mag_sum exceeds max magnitude)
            if (mag_sum[MAG_WIDTH]) begin
                // Overflow: magnitude too big for N-1 bits
                res[N-1]   = a_sign;           // Result sign same as inputs' sign
                res[N-2:0] = MAX_MAG;          // Saturate magnitude to max
            end else begin
                res[N-1]   = a_sign;
                res[N-2:0] = mag_sum[MAG_WIDTH-1:0];
            end
        end else begin
            // Different signs: subtract smaller magnitude from larger magnitude
            if (a_mag > b_mag) begin
                mag_diff = {1'b0, a_mag} - {1'b0, b_mag};
                result_sign = a_sign;  // sign of operand with larger magnitude
            end else if (b_mag > a_mag) begin
                mag_diff = {1'b0, b_mag} - {1'b0, a_mag};
                result_sign = b_sign;  // sign of operand with larger magnitude
            end else begin
                // magnitudes equal: result is zero (positive zero)
                mag_diff = 0;
                result_sign = 1'b0;
            end

            zero_result = (mag_diff == 0);

            if (zero_result) begin
                // Result is zero: all bits zero
                res = {N{1'b0}};
            end else begin
                // Result sign as determined
                // Check saturation (should not happen for subtraction)
                if (mag_diff[MAG_WIDTH]) begin
                    // Saturate magnitude if somehow overflowed (unlikely here)
                    res[N-1]   = result_sign;
                    res[N-2:0] = MAX_MAG;
                end else begin
                    res[N-1]   = result_sign;
                    res[N-2:0] = mag_diff[MAG_WIDTH-1:0];
                end
            end
        end

        // Assign output
        c = res;
    end

endmodule