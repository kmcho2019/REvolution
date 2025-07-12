module float_multi(
    input               clk,
    input               rst,
    input       [31:0]  a,
    input       [31:0]  b,
    output reg  [31:0]  z
);

    // Constants
    localparam EXP_BIAS = 127;

    // FSM states
    localparam IDLE      = 3'd0;
    localparam DECODE    = 3'd1;
    localparam MULTIPLY  = 3'd2;
    localparam NORMALIZE = 3'd3;
    localparam ROUND     = 3'd4;
    localparam PACK      = 3'd5;

    reg [2:0] state;

    // Stage DECODE registers - input split and special case detection
    reg         a_sign, b_sign;
    reg [7:0]   a_exp, b_exp;
    reg [22:0]  a_frac, b_frac;

    reg         a_is_zero, b_is_zero;
    reg         a_is_inf,  b_is_inf;
    reg         a_is_nan,  b_is_nan;

    reg [23:0]  a_mant, b_mant; // 24-bit mantissa with implicit bit

    reg         result_sign;

    // MULTIPLY stage registers
    reg [47:0]  mant_prod;   // product of mantissas
    reg signed [9:0] exp_sum; // wider for bias adjustment and overflow detection

    // Special cases propagated
    reg special_nan;
    reg special_inf;
    reg special_zero;

    // NORMALIZE stage registers
    reg [47:0]  mant_prod_norm;
    reg signed [9:0] exp_norm;
    reg [23:0]  mant_norm;      // 24-bit mantissa after normalization
    reg         guard_bit, round_bit, sticky_bit;

    // ROUND stage registers
    reg [24:0]  mant_rounded;  // 25-bit mantissa for rounding (including carry bit)
    reg signed [9:0] exp_rounded;
    reg         round_increment;

    // PACK stage registers
    reg [7:0]   final_exp;
    reg [22:0]  final_mantissa;
    reg         final_sign;

    // Helper signals for rounding
    wire lsb_mant_norm = mant_norm[0];

    // Sticky bit calculation helper (OR of all bits below round bit)
    function automatic bit sticky_calc;
        input [21:0] bits;
        integer i;
        begin
            sticky_calc = 1'b0;
            for (i = 0; i < 22; i = i + 1) begin
                if (bits[i]) sticky_calc = 1'b1;
            end
        end
    endfunction

    // FSM: Sequential logic for multi-cycle operation
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            state <= IDLE;
            z <= 32'd0;

            // Clear all registers
            a_sign <= 1'b0; b_sign <= 1'b0;
            a_exp <= 8'd0; b_exp <= 8'd0;
            a_frac <= 23'd0; b_frac <= 23'd0;
            a_is_zero <= 1'b0; b_is_zero <= 1'b0;
            a_is_inf <= 1'b0; b_is_inf <= 1'b0;
            a_is_nan <= 1'b0; b_is_nan <= 1'b0;
            a_mant <= 24'd0; b_mant <= 24'd0;
            result_sign <= 1'b0;

            mant_prod <= 48'd0;
            exp_sum <= 10'd0;

            special_nan <= 1'b0;
            special_inf <= 1'b0;
            special_zero <= 1'b0;

            mant_prod_norm <= 48'd0;
            exp_norm <= 10'd0;
            mant_norm <= 24'd0;
            guard_bit <= 1'b0;
            round_bit <= 1'b0;
            sticky_bit <= 1'b0;

            mant_rounded <= 25'd0;
            exp_rounded <= 10'd0;
            round_increment <= 1'b0;

            final_exp <= 8'd0;
            final_mantissa <= 23'd0;
            final_sign <= 1'b0;
        end else begin
            case (state)
            IDLE: begin
                // Immediately start decode stage on any clock after reset
                state <= DECODE;
            end

            DECODE: begin
                // Extract fields
                a_sign <= a[31];
                b_sign <= b[31];
                a_exp <= a[30:23];
                b_exp <= b[30:23];
                a_frac <= a[22:0];
                b_frac <= b[22:0];

                // Detect special values
                a_is_zero <= (a[30:23] == 8'd0) && (a[22:0] == 23'd0);
                b_is_zero <= (b[30:23] == 8'd0) && (b[22:0] == 23'd0);

                a_is_inf <= (a[30:23] == 8'hFF) && (a[22:0] == 23'd0);
                b_is_inf <= (b[30:23] == 8'hFF) && (b[22:0] == 23'd0);

                a_is_nan <= (a[30:23] == 8'hFF) && (a[22:0] != 23'd0);
                b_is_nan <= (b[30:23] == 8'hFF) && (b[22:0] != 23'd0);

                // Prepare mantissas with implicit leading bit for normalized numbers,
                // else leading 0 for denormals
                a_mant <= (a[30:23] == 8'd0) ? {1'b0, a[22:0]} : {1'b1, a[22:0]};
                b_mant <= (b[30:23] == 8'd0) ? {1'b0, b[22:0]} : {1'b1, b[22:0]};

                // Compute sign of result
                result_sign <= a[31] ^ b[31];

                // Prepare special flags for output priority
                special_nan <= 1'b0;
                special_inf <= 1'b0;
                special_zero <= 1'b0;

                state <= MULTIPLY;
            end

            MULTIPLY: begin
                // Multiply mantissas: 24x24 -> 48 bit product
                mant_prod <= a_mant * b_mant;

                // Calculate exponent sum with bias adjustment
                exp_sum <= $signed({1'b0, a_exp}) + $signed({1'b0, b_exp}) - EXP_BIAS;

                // Propagate special cases flags
                special_nan <= a_is_nan || b_is_nan;
                special_inf <= (a_is_inf || b_is_inf) && !(a_is_zero || b_is_zero);
                special_zero <= a_is_zero || b_is_zero;

                state <= NORMALIZE;
            end

            NORMALIZE: begin
                mant_prod_norm <= mant_prod;

                // Normalize product: if top bit 47 is set, shift right one bit and increment exponent
                if (mant_prod[47]) begin
                    mant_norm <= mant_prod[47:24]; // 24 bits: bits 47 down to 24 inclusive
                    exp_norm <= exp_sum + 10'd1;
                    guard_bit <= mant_prod[23];
                    round_bit <= mant_prod[22];
                    sticky_bit <= |mant_prod[21:0];
                end else begin
                    mant_norm <= mant_prod[46:23]; // 24 bits shifted left by 1 compared to above
                    exp_norm <= exp_sum;
                    guard_bit <= mant_prod[22];
                    round_bit <= mant_prod[21];
                    sticky_bit <= |mant_prod[20:0];
                end

                state <= ROUND;
            end

            ROUND: begin
                exp_rounded <= exp_norm;
                round_increment <= 1'b0;

                // Round to nearest even:
                // Add 1 if guard bit is 1 and (round bit or sticky bit or LSB of mantissa is 1)
                round_increment <= guard_bit && (round_bit || sticky_bit || mant_norm[0]);

                if (round_increment)
                    mant_rounded <= {1'b0, mant_norm} + 25'd1;
                else
                    mant_rounded <= {1'b0, mant_norm};

                state <= PACK;
            end

            PACK: begin
                final_sign <= result_sign;

                // Handle mantissa overflow from rounding carry-out (bit 24)
                if (mant_rounded[24]) begin
                    final_exp <= exp_rounded[7:0] + 8'd1;
                    // Shift mantissa right by 1, discard least significant bit (rounding)
                    final_mantissa <= mant_rounded[24:2];
                end else begin
                    final_exp <= exp_rounded[7:0];
                    final_mantissa <= mant_rounded[22:0];
                end

                // Assemble output considering special cases, overflow, and underflow
                if (special_nan) begin
                    // Quiet NaN: exponent all ones and mantissa MSB set to 1
                    z <= {1'b0, 8'hFF, 1'b1, 22'd0};
                end else if (special_inf && (a_is_zero || b_is_zero)) begin
                    // Inf * 0 = NaN
                    z <= {1'b0, 8'hFF, 1'b1, 22'd0};
                end else if (special_inf) begin
                    // Inf times non-zero = Inf with correct sign
                    z <= {final_sign, 8'hFF, 23'd0};
                end else if (special_zero) begin
                    // Zero times anything = zero with correct sign
                    z <= {final_sign, 31'd0};
                end else begin
                    // Normal case: check overflow and underflow exponent
                    if (final_exp >= 8'hFF) begin
                        // Overflow: represent as infinity
                        z <= {final_sign, 8'hFF, 23'd0};
                    end else if (final_exp <= 0) begin
                        // Underflow: flush to zero (denormals not supported)
                        z <= {final_sign, 31'd0};
                    end else begin
                        // Normal normalized number
                        z <= {final_sign, final_exp, final_mantissa};
                    end
                end

                state <= IDLE; // Ready for next operation
            end

            default: state <= IDLE;
            endcase
        end
    end

endmodule