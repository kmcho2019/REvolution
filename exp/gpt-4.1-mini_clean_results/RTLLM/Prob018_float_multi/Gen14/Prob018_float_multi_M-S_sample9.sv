module float_multi(
    input               clk,
    input               rst,        // synchronous active high reset
    input       [31:0]  a,
    input       [31:0]  b,
    output reg  [31:0]  z
);

    // Parameters
    localparam EXP_BIAS = 127;
    localparam EXP_MAX  = 8'hFF;
    localparam EXP_MIN  = 8'd0;

    // Cycle counter
    reg [2:0] counter;

    // Internal registers
    reg a_sign, b_sign, z_sign;
    reg [7:0] a_exponent, b_exponent;
    reg [7:0] z_exponent;
    reg [23:0] a_mantissa, b_mantissa;
    reg [49:0] product;            // 24x24 mantissa product max 48 bits, plus margin
    reg product_msb;

    // Rounding bits
    reg guard_bit, round_bit, sticky_bit;

    // Flags for special cases
    reg a_zero, b_zero;
    reg a_denorm, b_denorm;
    reg a_inf, b_inf;
    reg a_nan, b_nan;

    // Intermediate normalized mantissa and exponent
    reg [23:0] norm_mantissa;
    reg [8:0] norm_exponent; // 9 bits to hold exponent +1 if normalized shift occurs

    // Rounding result signals
    reg [24:0] rounded_mantissa_pre;
    reg mantissa_carry;
    reg [22:0] final_mantissa;
    reg [8:0] final_exponent_pre;

    // Exponent overflow/underflow detection
    reg exponent_overflow;
    reg exponent_underflow;

    // Sign result
    wire res_sign;

    // Temp signals for rounding logic
    wire round_increment;

    // Extract parts function (to use in cycle 1)
    wire [7:0] a_exp_in = a[30:23];
    wire [22:0] a_frac_in = a[22:0];
    wire a_sign_in = a[31];

    wire [7:0] b_exp_in = b[30:23];
    wire [22:0] b_frac_in = b[22:0];
    wire b_sign_in = b[31];

    // Calculate sign XOR once combinationally
    assign res_sign = a_sign ^ b_sign;

    // Sticky bit helper function
    function sticky_or;
        input [21:0] bits;
        integer i;
        begin
            sticky_or = 1'b0;
            for(i=0;i<22;i=i+1) begin
                if(bits[i])
                    sticky_or = 1'b1;
            end
        end
    endfunction

    always @(posedge clk) begin
        if (rst) begin
            counter <= 3'd0;
            z <= 32'd0;

            // Clear internal regs
            a_sign <= 1'b0;
            b_sign <= 1'b0;
            a_exponent <= 8'd0;
            b_exponent <= 8'd0;
            a_mantissa <= 24'd0;
            b_mantissa <= 24'd0;
            product <= 50'd0;
            z_sign <= 1'b0;
            z_exponent <= 8'd0;
            norm_mantissa <= 24'd0;
            norm_exponent <= 9'd0;
            guard_bit <= 1'b0;
            round_bit <= 1'b0;
            sticky_bit <= 1'b0;
            mantissa_carry <= 1'b0;
            final_mantissa <= 23'd0;
            final_exponent_pre <= 9'd0;
            exponent_overflow <= 1'b0;
            exponent_underflow <= 1'b0;
            a_zero <= 1'b0;
            b_zero <= 1'b0;
            a_denorm <= 1'b0;
            b_denorm <= 1'b0;
            a_inf <= 1'b0;
            b_inf <= 1'b0;
            a_nan <= 1'b0;
            b_nan <= 1'b0;
        end else begin
            case(counter)
                3'd0: begin
                    // Idle cycle, start extraction next cycle
                    counter <= 3'd1;
                end
                3'd1: begin
                    // Extract signs, exponent, mantissa and detect special cases
                    a_sign <= a_sign_in;
                    b_sign <= b_sign_in;
                    a_exponent <= a_exp_in;
                    b_exponent <= b_exp_in;

                    // Detect special cases for a
                    a_zero <= (a_exp_in == 8'd0) && (a_frac_in == 23'd0);
                    a_denorm <= (a_exp_in == 8'd0) && (a_frac_in != 23'd0);
                    a_inf <= (a_exp_in == 8'hFF) && (a_frac_in == 23'd0);
                    a_nan <= (a_exp_in == 8'hFF) && (a_frac_in != 23'd0);

                    // Detect special cases for b
                    b_zero <= (b_exp_in == 8'd0) && (b_frac_in == 23'd0);
                    b_denorm <= (b_exp_in == 8'd0) && (b_frac_in != 23'd0);
                    b_inf <= (b_exp_in == 8'hFF) && (b_frac_in == 23'd0);
                    b_nan <= (b_exp_in == 8'hFF) && (b_frac_in != 23'd0);

                    // Prepare mantissas with implicit leading 1 for normal, 0 for denorm/zero
                    a_mantissa <= (a_exp_in == 8'd0) ? {1'b0, a_frac_in} : {1'b1, a_frac_in};
                    b_mantissa <= (b_exp_in == 8'd0) ? {1'b0, b_frac_in} : {1'b1, b_frac_in};

                    z_sign <= a_sign_in ^ b_sign_in;

                    counter <= 3'd2;
                end
                3'd2: begin
                    // Multiply mantissas (24x24)
                    // 24*24=48 bits, stored in product[49:0] (extra bits for safe rounding)
                    product <= a_mantissa * b_mantissa;
                    // Add exponents, adjust bias; treat denormals as exp=1 for calculation
                    // We'll save exponents separately and calculate sum next cycle
                    counter <= 3'd3;
                end
                3'd3: begin
                    // Calculate exponent sum and normalize mantissa product
                    // Extract the msb of the product (bit 47)
                    product_msb <= product[47];

                    // Calculate exponents with denormal correction
                    // Use 9-bit for exponent calculations (allow +1 for normalization)
                    // For denormals exponent=1, normal use actual exponent
                    // Calculate sum exponent = a_exp_adj + b_exp_adj - bias
                    reg [8:0] a_exp_adj;
                    reg [8:0] b_exp_adj;
                    reg [8:0] exp_sum;
                    a_exp_adj = (a_exponent == 8'd0) ? 9'd1 : {1'b0,a_exponent};
                    b_exp_adj = (b_exponent == 8'd0) ? 9'd1 : {1'b0,b_exponent};
                    exp_sum = a_exp_adj + b_exp_adj - EXP_BIAS;

                    // Normalize product:
                    // if MSB = 1, mantissa is top 24 bits of product (bits 47:24)
                    // if MSB = 0, shift left 1 (product << 1), and decrement exponent by 1
                    if(product[47]) begin
                        norm_mantissa <= product[47:24];
                        norm_exponent <= exp_sum + 9'd1;
                        // Extract rounding bits
                        guard_bit <= product[23];
                        round_bit <= product[22];
                        sticky_bit <= |product[21:0];
                    end else begin
                        norm_mantissa <= product[46:23];
                        norm_exponent <= exp_sum;
                        guard_bit <= product[22];
                        round_bit <= product[21];
                        sticky_bit <= |product[20:0];
                    end

                    counter <= 3'd4;
                end
                3'd4: begin
                    // Rounding
                    // Round to nearest even:
                    // round_increment = guard & (round | sticky | LSB)
                    round_increment <= guard_bit && (round_bit || sticky_bit || norm_mantissa[0]);

                    rounded_mantissa_pre <= {1'b0, norm_mantissa} + (round_increment ? 25'd1 : 25'd0);

                    // Check if carry out (bit 24) after rounding
                    mantissa_carry <= rounded_mantissa_pre[24];

                    // Adjust final mantissa and exponent accordingly
                    if(rounded_mantissa_pre[24]) begin
                        final_mantissa <= rounded_mantissa_pre[24:2]; // shifted right 1
                        final_exponent_pre <= norm_exponent + 9'd1;
                    end else begin
                        final_mantissa <= rounded_mantissa_pre[22:0];
                        final_exponent_pre <= norm_exponent;
                    end

                    counter <= 3'd5;
                end
                3'd5: begin
                    // Handle exponent overflow and underflow
                    exponent_overflow <= (final_exponent_pre >= 9'd255);
                    exponent_underflow <= (final_exponent_pre <= 9'd0);

                    // Compose final exponent for output (clamp if overflow/underflow)
                    if(exponent_overflow)
                        z_exponent <= 8'hFF; // Inf
                    else if(exponent_underflow)
                        z_exponent <= 8'd0;  // zero (flush denormal)
                    else
                        z_exponent <= final_exponent_pre[7:0];

                    // Special cases resolution
                    if(a_nan || b_nan) begin
                        // Quiet NaN: sign=0, exp=0xFF, MSB mantissa=1
                        z <= {1'b0, 8'hFF, 1'b1, 22'd0};
                    end else if ((a_inf && b_zero) || (b_inf && a_zero)) begin
                        // Inf * 0 = NaN
                        z <= {1'b0, 8'hFF, 1'b1, 22'd0};
                    end else if (a_inf || b_inf) begin
                        // Inf * non-zero = Inf with correct sign
                        z <= {z_sign, 8'hFF, 23'd0};
                    end else if (a_zero || b_zero) begin
                        // zero * anything = zero with correct sign
                        z <= {z_sign, 31'd0};
                    end else begin
                        if(exponent_overflow) begin
                            // overflow to Inf
                            z <= {z_sign, 8'hFF, 23'd0};
                        end else if (exponent_underflow) begin
                            // underflow to zero
                            z <= {z_sign, 31'd0};
                        end else begin
                            // normal result
                            z <= {z_sign, z_exponent, final_mantissa};
                        end
                    end
                    counter <= 3'd5; // stay here until reset (or external control for next op)
                end
                default: begin
                    counter <= 3'd0;
                end
            endcase
        end
    end

endmodule