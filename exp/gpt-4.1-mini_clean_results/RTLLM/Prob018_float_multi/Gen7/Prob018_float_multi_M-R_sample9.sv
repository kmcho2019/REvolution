module float_multi(
    input  wire        clk,
    input  wire        rst,
    input  wire [31:0] a,
    input  wire [31:0] b,
    output reg  [31:0] z
);

    localparam EXP_BIAS = 8'd127;

    // State encoding
    typedef enum reg [2:0] {
        IDLE       = 3'd0,
        EXTRACT    = 3'd1,
        MULTIPLY   = 3'd2,
        NORMALIZE  = 3'd3,
        ROUND      = 3'd4,
        OUTPUT     = 3'd5
    } state_t;

    reg [2:0] state, next_state;

    // Input fields
    reg        a_sign, b_sign;
    reg [7:0]  a_exp, b_exp;
    reg [23:0] a_mantissa, b_mantissa; // with implicit leading 1 or zero for denormals

    // Special flags
    reg a_zero, b_zero, a_inf, b_inf, a_nan, b_nan;
    reg special_nan, special_inf, special_zero, special_nan_out;

    // Intermediate signals
    reg [47:0] product;
    reg [9:0]  exponent_sum;
    reg        z_sign;

    reg [47:0] norm_product;
    reg [9:0]  norm_exponent;

    // Rounding bits
    reg guard_bit, round_bit, sticky_bit;
    reg [23:0] z_mantissa;

    reg round_increment;
    reg [24:0] mant_rounded;

    // Sequential state and registers update
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            state <= IDLE;
            z <= 32'd0;

            // Reset registers
            a_sign <= 1'b0; b_sign <= 1'b0;
            a_exp <= 8'd0; b_exp <= 8'd0;
            a_mantissa <= 24'd0; b_mantissa <= 24'd0;

            a_zero <= 1'b0; b_zero <= 1'b0;
            a_inf <= 1'b0; b_inf <= 1'b0;
            a_nan <= 1'b0; b_nan <= 1'b0;

            special_nan <= 1'b0; special_inf <= 1'b0; special_zero <= 1'b0; special_nan_out <= 1'b0;

            product <= 48'd0;
            exponent_sum <= 10'd0;
            z_sign <= 1'b0;

            norm_product <= 48'd0;
            norm_exponent <= 10'd0;

            guard_bit <= 1'b0; round_bit <= 1'b0; sticky_bit <= 1'b0;

            z_mantissa <= 24'd0;

            round_increment <= 1'b0;
            mant_rounded <= 25'd0;
        end else begin
            state <= next_state;

            case (state)
            IDLE: begin
                z <= 32'd0; // Optional, can hold previous result
            end

            EXTRACT: begin
                // Extract sign
                a_sign <= a[31];
                b_sign <= b[31];

                // Extract exponent
                a_exp <= a[30:23];
                b_exp <= b[30:23];

                // Extract mantissa with implicit leading 1 if normalized, else 0 for denormals
                a_mantissa <= (a[30:23] == 8'd0) ? {1'b0, a[22:0]} : {1'b1, a[22:0]};
                b_mantissa <= (b[30:23] == 8'd0) ? {1'b0, b[22:0]} : {1'b1, b[22:0]};

                // Detect special cases
                a_zero <= (a[30:23] == 8'd0) && (a[22:0] == 23'd0);
                b_zero <= (b[30:23] == 8'd0) && (b[22:0] == 23'd0);

                a_inf  <= (a[30:23] == 8'hFF) && (a[22:0] == 23'd0);
                b_inf  <= (b[30:23] == 8'hFF) && (b[22:0] == 23'd0);

                a_nan  <= (a[30:23] == 8'hFF) && (a[22:0] != 23'd0);
                b_nan  <= (b[30:23] == 8'hFF) && (b[22:0] != 23'd0);

                // Prepare special cases flags
                special_nan <= a_nan || b_nan;
                special_nan_out <= ( (a_inf && b_zero) || (b_inf && a_zero) );
                special_inf <= (a_inf || b_inf) && !special_nan_out;
                special_zero <= (a_zero || b_zero) && !special_nan_out && !special_inf;
            end

            MULTIPLY: begin
                product <= a_mantissa * b_mantissa;
                exponent_sum <= a_exp + b_exp - EXP_BIAS;
                z_sign <= a_sign ^ b_sign;
            end

            NORMALIZE: begin
                if (product[47]) begin
                    norm_product <= product >> 1;
                    norm_exponent <= exponent_sum + 1;
                end else begin
                    norm_product <= product;
                    norm_exponent <= exponent_sum;
                end

                // Extract rounding bits
                guard_bit <= (product[23]) || (product[47] ? product[22] : 0); // Corrected below in combinational
                round_bit <= (product[22]);
                sticky_bit <= |product[21:0];

                // Mantissa bits extraction corrected in combinational block below
            end

            ROUND: begin
                // Rounding and mantissa adjustment done in combinational, values latched here
                mant_rounded <= {1'b0, z_mantissa} + {24'd0, round_increment};

                if (mant_rounded[24]) begin
                    z_mantissa <= mant_rounded[24:1];
                    norm_exponent <= norm_exponent + 1;
                end else begin
                    z_mantissa <= mant_rounded[23:0];
                    // norm_exponent unchanged
                end
            end

            OUTPUT: begin
                // Output result based on special cases and adjusted exponent/mantissa
                if (special_nan || special_nan_out) begin
                    z <= {1'b0, 8'hFF, 1'b1, 22'd0}; // Quiet NaN
                end else if (special_inf) begin
                    z <= {z_sign, 8'hFF, 23'd0}; // Infinity
                end else if (special_zero) begin
                    z <= {z_sign, 31'd0}; // Zero
                end else if (norm_exponent >= 8'hFF) begin
                    z <= {z_sign, 8'hFF, 23'd0}; // Overflow to Infinity
                end else if (norm_exponent <= 0) begin
                    z <= {z_sign, 31'd0}; // Underflow to zero (no subnormals)
                end else begin
                    z <= {z_sign, norm_exponent[7:0], z_mantissa[22:0]};
                end
            end

            default: ;
            endcase
        end
    end

    // Next state logic (combinational)
    always @(*) begin
        case (state)
        IDLE:       next_state = EXTRACT;
        EXTRACT:    next_state = MULTIPLY;
        MULTIPLY:   next_state = NORMALIZE;
        NORMALIZE:  next_state = ROUND;
        ROUND:      next_state = OUTPUT;
        OUTPUT:     next_state = IDLE;
        default:    next_state = IDLE;
        endcase
    end

    // Combinational rounding and mantissa extraction

    always @(*) begin
        // Correct rounding bits extraction based on norm_product which is product possibly shifted right by 1

        // Use norm_product set in NORMALIZE state
        guard_bit = norm_product[23];
        round_bit = norm_product[22];
        sticky_bit = |norm_product[21:0];

        // Mantissa bits: top 24 bits starting at bit 46 down to 23 after normalization
        // Note: norm_product is assigned in NORMALIZE state as product or product>>1,
        // so bits [46:23] are z_mantissa bits

        z_mantissa = norm_product[46:23];

        // round_increment computed as round to nearest even
        round_increment = guard_bit && (round_bit || sticky_bit || z_mantissa[0]);
    end

endmodule