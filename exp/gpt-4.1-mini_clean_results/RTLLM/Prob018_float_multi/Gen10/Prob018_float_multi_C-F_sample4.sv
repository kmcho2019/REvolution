module float_multi(
    input               clk,
    input               rst,
    input       [31:0]  a,
    input       [31:0]  b,
    output reg  [31:0]  z
);

    // Parameters
    localparam EXP_BIAS = 127;

    // FSM states
    localparam IDLE       = 3'd0;
    localparam DECODE     = 3'd1;
    localparam MULTIPLY   = 3'd2;
    localparam NORMALIZE  = 3'd3;
    localparam ROUND_PACK = 3'd4;

    reg [2:0] cycle;

    // Input fields extracted
    reg a_sign, b_sign;
    reg [7:0] a_exp, b_exp;
    reg [22:0] a_frac, b_frac;

    // Special input flags
    reg a_is_zero, b_is_zero;
    reg a_is_inf,  b_is_inf;
    reg a_is_nan,  b_is_nan;

    // Prepared mantissas with implicit leading bit for normalized numbers
    reg [23:0] a_mantissa, b_mantissa;

    // Result sign
    reg z_sign;

    // Exponent sum (signed 10 bits for calculation safety)
    reg signed [9:0] exp_sum;

    // Mantissa product 24b x 24b = 48b
    reg [47:0] product;

    // Normalized mantissa and exponent (after normalization)
    reg [23:0] norm_mantissa;
    reg signed [9:0] norm_exp;

    // Rounding bits
    reg guard_bit, round_bit, sticky_bit;

    // Rounded mantissa after rounding, 25 bits to detect carry out
    reg [24:0] rounded_mantissa;

    // Final exponent and mantissa output registers
    reg [7:0] final_exp;
    reg [22:0] final_mantissa;

    // Flags for special final output
    reg special_nan;
    reg special_inf;
    reg special_zero;

    // Sticky bit calculation helper
    wire sticky_or;

    // Sticky calculation OR reduction on product lower bits
    assign sticky_or = |(cycle == NORMALIZE ? (product[21:0]) : 22'b0);

    // FSM controlling sequential multi-cycle operation
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            cycle <= IDLE;

            // Clear all registers and outputs
            a_sign <= 0; b_sign <= 0;
            a_exp <= 0; b_exp <= 0;
            a_frac <= 0; b_frac <= 0;
            a_is_zero <= 0; b_is_zero <= 0;
            a_is_inf <= 0; b_is_inf <= 0;
            a_is_nan <= 0; b_is_nan <= 0;
            a_mantissa <= 0; b_mantissa <= 0;

            z_sign <= 0;
            exp_sum <= 0;
            product <= 0;
            norm_mantissa <= 0;
            norm_exp <= 0;

            guard_bit <= 0; round_bit <= 0; sticky_bit <= 0;
            rounded_mantissa <= 0;

            final_exp <= 0;
            final_mantissa <= 0;

            special_nan <= 0;
            special_inf <= 0;
            special_zero <= 0;

            z <= 32'd0;

        end else begin
            case (cycle)
                IDLE: begin
                    // Begin processing immediately next cycle
                    cycle <= DECODE;
                end

                DECODE: begin
                    // Extract sign, exponent, fraction from inputs
                    a_sign <= a[31];
                    b_sign <= b[31];
                    a_exp <= a[30:23];
                    b_exp <= b[30:23];
                    a_frac <= a[22:0];
                    b_frac <= b[22:0];

                    // Special cases detection
                    a_is_zero <= (a[30:23] == 8'd0) && (a[22:0] == 23'd0);
                    b_is_zero <= (b[30:23] == 8'd0) && (b[22:0] == 23'd0);

                    a_is_inf <= (a[30:23] == 8'hFF) && (a[22:0] == 23'd0);
                    b_is_inf <= (b[30:23] == 8'hFF) && (b[22:0] == 23'd0);

                    a_is_nan <= (a[30:23] == 8'hFF) && (a[22:0] != 23'd0);
                    b_is_nan <= (b[30:23] == 8'hFF) && (b[22:0] != 23'd0);

                    // Prepare mantissas (implicit 1 for normalized, 0 for denormal)
                    a_mantissa <= (a_exp == 8'd0) ? {1'b0, a_frac} : {1'b1, a_frac};
                    b_mantissa <= (b_exp == 8'd0) ? {1'b0, b_frac} : {1'b1, b_frac};

                    // Calculate preliminary sign
                    z_sign <= a[31] ^ b[31];

                    cycle <= MULTIPLY;
                end

                MULTIPLY: begin
                    // Multiply mantissas (24b x 24b = 48b)
                    product <= a_mantissa * b_mantissa;

                    // Add exponents and subtract bias
                    exp_sum <= $signed({1'b0, a_exp}) + $signed({1'b0, b_exp}) - EXP_BIAS;

                    // Prepare flags for special cases for final stage
                    special_nan <= a_is_nan || b_is_nan;
                    special_inf <= (a_is_inf || b_is_inf) && !(a_is_zero || b_is_zero);
                    special_zero <= a_is_zero || b_is_zero;

                    cycle <= NORMALIZE;
                end

                NORMALIZE: begin
                    // Normalize mantissa product and adjust exponent

                    // Check MSB (bit 47) to decide normalization shift
                    if (product[47]) begin
                        // Leading one at bit 47: shift mantissa right by 24 to get 24-bit mantissa
                        norm_mantissa <= product[47:24];
                        norm_exp <= exp_sum + 1; // exponent increment due to shift

                        // Rounding bits: guard = bit 23, round = bit 22, sticky = OR of bits 21:0
                        guard_bit <= product[23];
                        round_bit <= product[22];
                        sticky_bit <= |product[21:0];
                    end else begin
                        // Leading one at bit 46 or less: shift mantissa right by 23
                        norm_mantissa <= product[46:23];
                        norm_exp <= exp_sum;

                        guard_bit <= product[22];
                        round_bit <= product[21];
                        sticky_bit <= |product[20:0];
                    end

                    cycle <= ROUND_PACK;
                end

                ROUND_PACK: begin
                    // Round-to-nearest-even implementation

                    // Determine if rounding increment needed
                    // round if guard=1 and (round=1 or sticky=1 or LSB of mantissa=1)
                    if (guard_bit && (round_bit || sticky_bit || norm_mantissa[0])) begin
                        rounded_mantissa <= {1'b0, norm_mantissa} + 25'd1;
                    end else begin
                        rounded_mantissa <= {1'b0, norm_mantissa};
                    end

                    // Prepare exponent and mantissa after rounding in non-blocking to use in output assembly below
                    // Note: rounding can cause mantissa overflow (bit 24 = carry-out)
                    // will adjust exponent accordingly below

                    cycle <= IDLE; // Output assembled now below
                end

                default: cycle <= IDLE;
            endcase

            // Assemble output on ROUND_PACK cycle (one cycle after rounding calculation)
            if (cycle == ROUND_PACK) begin
                // Adjust exponent if mantissa overflowed after rounding
                if (rounded_mantissa[24]) begin
                    final_exp <= norm_exp + 1;
                    final_mantissa <= rounded_mantissa[24:2]; // shift right by 1 discarding LSB
                end else begin
                    final_exp <= norm_exp[7:0];
                    final_mantissa <= rounded_mantissa[22:0];
                end

                // Handle special cases priority:

                // NaN: exponent=255, mantissa MSB=1 (quiet NaN)
                if (special_nan) begin
                    z <= {1'b0, 8'hFF, 1'b1, 22'd0};
                end
                // Inf * 0 = NaN
                else if (special_inf && special_zero) begin
                    z <= {1'b0, 8'hFF, 1'b1, 22'd0};
                end
                // Infinity propagation
                else if (special_inf) begin
                    z <= {z_sign, 8'hFF, 23'd0};
                end
                // Zero propagation
                else if (special_zero) begin
                    z <= {z_sign, 31'd0};
                end
                else begin
                    // Normal cases: check for exponent overflow and underflow

                    if (final_exp >= 8'hFF) begin
                        // Overflow -> Infinity
                        z <= {z_sign, 8'hFF, 23'd0};
                    end else if (final_exp <= 0) begin
                        // Underflow/denormal flush to zero
                        z <= {z_sign, 31'd0};
                    end else begin
                        // Normal number assembly
                        z <= {z_sign, final_exp, final_mantissa};
                    end
                end
            end
        end
    end

endmodule