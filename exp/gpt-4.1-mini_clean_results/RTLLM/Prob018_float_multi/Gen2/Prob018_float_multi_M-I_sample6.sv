module float_multi(
    input clk,
    input rst,
    input [31:0] a,
    input [31:0] b,
    output reg [31:0] z
);

    localparam EXP_BIAS = 127;
    localparam EXP_MAX = 8'hFF;

    reg [2:0] counter;

    // Input decomposed fields
    reg a_sign, b_sign, z_sign;
    reg [7:0] a_exp, b_exp;
    reg [22:0] a_frac, b_frac;
    reg [23:0] a_mant, b_mant; // 24 bits: implicit leading 1 for normal numbers, 0 for denormals

    // Special flags
    reg a_nan, b_nan, a_inf, b_inf, a_zero, b_zero;

    // Product registers
    reg [47:0] mant_product; // 24x24 product is 48 bits
    reg [8:0] exp_sum;       // Sum of exponents minus bias, can overflow 8 bits so use 9 bits

    // Normalization
    reg normalized_shift; // 1 if product MSB at bit 47, else 0 and shift left by 1
    reg [47:0] normalized_mant;

    // Rounding bits
    reg guard_bit, round_bit, sticky_bit;

    // Rounded mantissa and exponent after rounding
    reg [23:0] rounded_mant;  // 24 bits including implicit leading bit
    reg [8:0] rounded_exp;

    // Signals for rounding increment
    reg rounding_increment;

    // Extract fields from inputs (combinational)
    wire [7:0] a_exp_in = a[30:23];
    wire [7:0] b_exp_in = b[30:23];
    wire [22:0] a_frac_in = a[22:0];
    wire [22:0] b_frac_in = b[22:0];
    wire a_sign_in = a[31];
    wire b_sign_in = b[31];

    // Detect special cases
    wire a_is_nan = (a_exp_in == EXP_MAX) && (a_frac_in != 0);
    wire b_is_nan = (b_exp_in == EXP_MAX) && (b_frac_in != 0);
    wire a_is_inf = (a_exp_in == EXP_MAX) && (a_frac_in == 0);
    wire b_is_inf = (b_exp_in == EXP_MAX) && (b_frac_in == 0);
    wire a_is_zero = (a_exp_in == 0) && (a_frac_in == 0);
    wire b_is_zero = (b_exp_in == 0) && (b_frac_in == 0);

    // Compute sign output
    wire sign_out = a_sign ^ b_sign;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            counter <= 3'd0;
            z <= 32'd0;

            a_sign <= 1'b0;
            b_sign <= 1'b0;
            z_sign <= 1'b0;

            a_exp <= 8'd0;
            b_exp <= 8'd0;
            a_frac <= 23'd0;
            b_frac <= 23'd0;

            a_mant <= 24'd0;
            b_mant <= 24'd0;

            a_nan <= 1'b0;
            b_nan <= 1'b0;
            a_inf <= 1'b0;
            b_inf <= 1'b0;
            a_zero <= 1'b0;
            b_zero <= 1'b0;

            mant_product <= 48'd0;
            exp_sum <= 9'd0;

            normalized_shift <= 1'b0;
            normalized_mant <= 48'd0;

            guard_bit <= 1'b0;
            round_bit <= 1'b0;
            sticky_bit <= 1'b0;

            rounded_mant <= 24'd0;
            rounded_exp <= 9'd0;

            rounding_increment <= 1'b0;
        end else begin
            case (counter)
                3'd0: begin
                    // Latch inputs and decompose
                    a_sign <= a_sign_in;
                    b_sign <= b_sign_in;

                    a_exp <= a_exp_in;
                    b_exp <= b_exp_in;

                    a_frac <= a_frac_in;
                    b_frac <= b_frac_in;

                    a_nan <= a_is_nan;
                    b_nan <= b_is_nan;
                    a_inf <= a_is_inf;
                    b_inf <= b_is_inf;
                    a_zero <= a_is_zero;
                    b_zero <= b_is_zero;

                    // Prepare mantissas: 
                    // If normalized (exp!=0) -> implicit leading 1
                    // If denormalized (exp==0) -> leading 0
                    a_mant <= (a_exp_in == 0) ? {1'b0, a_frac_in} : {1'b1, a_frac_in};
                    b_mant <= (b_exp_in == 0) ? {1'b0, b_frac_in} : {1'b1, b_frac_in};

                    z_sign <= sign_out;

                    counter <= 3'd1;
                end
                3'd1: begin
                    // Handle special cases immediately:

                    if (a_nan || b_nan) begin
                        // Any input NaN => quiet NaN output (quiet bit set)
                        z <= {1'b0, 8'hFF, 1'b1, 22'd0};
                        counter <= 3'd0;
                    end else if ((a_inf && b_zero) || (b_inf && a_zero)) begin
                        // inf * 0 => NaN
                        z <= {1'b0, 8'hFF, 1'b1, 22'd0};
                        counter <= 3'd0;
                    end else if (a_inf || b_inf) begin
                        // Infinity times anything non-zero non-NaN => infinity with correct sign
                        z <= {sign_out, 8'hFF, 23'd0};
                        counter <= 3'd0;
                    end else if (a_zero || b_zero) begin
                        // Zero times anything non-inf non-NaN => zero with correct sign
                        z <= {sign_out, 31'd0};
                        counter <= 3'd0;
                    end else begin
                        // Normal multiplication

                        // Multiply mantissas (24x24=48 bits)
                        mant_product <= a_mant * b_mant;

                        // Calculate exponent sum minus bias (using 9 bits for safety)
                        // exponent = a_exp + b_exp - bias
                        exp_sum <= a_exp + b_exp - EXP_BIAS;

                        counter <= 3'd2;
                    end
                end
                3'd2: begin
                    // Normalize mantissa and prepare rounding bits

                    if (mant_product[47] == 1'b1) begin
                        normalized_shift <= 1'b1;
                        normalized_mant <= mant_product;
                        rounded_exp <= exp_sum + 1;
                    end else begin
                        normalized_shift <= 1'b0;
                        normalized_mant <= mant_product << 1;
                        rounded_exp <= exp_sum;
                    end

                    counter <= 3'd3;
                end
                3'd3: begin
                    // Extract mantissa, guard, round, sticky bits and compute rounding increment

                    if (normalized_shift) begin
                        // MSB at bit 47

                        // Mantissa bits (including implicit leading 1): bits [46:23] -> 24 bits
                        rounded_mant <= normalized_mant[46:23];

                        guard_bit <= normalized_mant[22];
                        round_bit <= normalized_mant[21];
                        sticky_bit <= |normalized_mant[20:0];
                    end else begin
                        // MSB at bit 46 after shift

                        // Mantissa bits: bits [45:22]
                        rounded_mant <= normalized_mant[45:22];

                        guard_bit <= normalized_mant[21];
                        round_bit <= normalized_mant[20];
                        sticky_bit <= |normalized_mant[19:0];
                    end

                    // Determine rounding increment (round to nearest even)
                    // round_up if guard=1 and (round=1 or sticky=1 or LSB=1)
                    if (guard_bit && (round_bit || sticky_bit || rounded_mant[0])) begin
                        rounding_increment <= 1'b1;
                    end else begin
                        rounding_increment <= 1'b0;
                    end

                    counter <= 3'd4;
                end
                3'd4: begin
                    // Apply rounding increment, handle mantissa overflow after rounding

                    if (rounding_increment) begin
                        // Add 1 to mantissa
                        {rounded_mant, rounded_exp} <= {rounded_mant, rounded_exp} + {24'd1, 9'd0};

                        // After increment, check for mantissa overflow: 
                        // max mantissa is 24'hFFFFFF; if exceeded, shift right and increment exponent
                        // Because adding 1 to 24'hFFFFFF = 0x1000000 (25 bits), so check MSB at bit 24 (0-based)
                        if (rounded_mant[23]) begin // bit 23 is MSB of 24-bit mantissa, if set after rounding, overflow
                            // overflow -> shift right 1 bit and increment exponent
                            rounded_mant <= rounded_mant >> 1;
                            rounded_exp <= rounded_exp + 1;
                        end
                    end

                    counter <= 3'd5;
                end
                3'd5: begin
                    // Handle exponent overflow/underflow and pack output

                    // Overflow exponent: set to infinity
                    if (rounded_exp >= EXP_MAX) begin
                        z <= {z_sign, 8'hFF, 23'd0};
                    end
                    // Underflow exponent or zero or subnormal, output zero for simplicity (no subnormal support)
                    else if (rounded_exp <= 0) begin
                        z <= {z_sign, 31'd0};
                    end else begin
                        // Normal number, remove implicit leading 1 and store fraction bits [22:0]
                        z <= {z_sign, rounded_exp[7:0], rounded_mant[22:0]};
                    end

                    counter <= 3'd0; // Ready for next operation
                end
                default: begin
                    counter <= 3'd0;
                end
            endcase
        end
    end

endmodule