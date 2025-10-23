module float_multi(
    input               clk,
    input               rst,
    input       [31:0]  a,
    input       [31:0]  b,
    output reg  [31:0]  z
);

    localparam EXP_BIAS = 127;

    reg [2:0] counter;

    // Stage 0: latch inputs and extract fields
    reg         a_sign, b_sign;
    reg [7:0]   a_exp, b_exp;
    reg [22:0]  a_frac, b_frac;

    reg         a_zero, b_zero;
    reg         a_inf, b_inf;
    reg         a_nan, b_nan;

    // Stage 1: mantissa prep and exponent addition
    reg [23:0] a_mantissa;
    reg [23:0] b_mantissa;
    reg [9:0]  exp_sum;        // 10-bit to handle overflow
    reg        sign_res;

    // Stage 2: multiplication product
    reg [47:0] product;        // 24x24 multiplication result

    // Stage 3: normalization
    reg [23:0] norm_mantissa;
    reg [9:0]  norm_exponent;
    reg        guard_bit;
    reg        round_bit;
    reg        sticky_bit;

    // Stage 4: rounding and exponent adjustment
    reg [24:0] rounded_mantissa; // 25 bits to catch rounding overflow
    reg [9:0]  rounded_exponent;

    // Sticky bit calculation helper function
    function automatic bit calc_sticky(input [21:0] bits);
        integer i;
        begin
            calc_sticky = 1'b0;
            for (i=0; i<22; i=i+1)
                if (bits[i]) calc_sticky = 1'b1;
        end
    endfunction

    // On reset
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            counter <= 3'd0;
            z <= 32'd0;

            // Clear all pipeline registers
            a_sign <= 1'b0; b_sign <= 1'b0;
            a_exp <= 8'd0; b_exp <= 8'd0;
            a_frac <= 23'd0; b_frac <= 23'd0;

            a_zero <= 1'b0; b_zero <= 1'b0;
            a_inf <= 1'b0; b_inf <= 1'b0;
            a_nan <= 1'b0; b_nan <= 1'b0;

            a_mantissa <= 24'd0;
            b_mantissa <= 24'd0;
            exp_sum <= 10'd0;
            sign_res <= 1'b0;

            product <= 48'd0;

            norm_mantissa <= 24'd0;
            norm_exponent <= 10'd0;
            guard_bit <= 1'b0;
            round_bit <= 1'b0;
            sticky_bit <= 1'b0;

            rounded_mantissa <= 25'd0;
            rounded_exponent <= 10'd0;
        end else begin
            case (counter)
                3'd0: begin
                    // Capture inputs and extract fields
                    a_sign <= a[31];
                    b_sign <= b[31];

                    a_exp <= a[30:23];
                    b_exp <= b[30:23];

                    a_frac <= a[22:0];
                    b_frac <= b[22:0];

                    // Identify special cases
                    a_zero <= (a[30:23] == 8'd0) && (a[22:0] == 23'd0);
                    b_zero <= (b[30:23] == 8'd0) && (b[22:0] == 23'd0);

                    a_inf <= (a[30:23] == 8'hFF) && (a[22:0] == 23'd0);
                    b_inf <= (b[30:23] == 8'hFF) && (b[22:0] == 23'd0);

                    a_nan <= (a[30:23] == 8'hFF) && (a[22:0] != 23'd0);
                    b_nan <= (b[30:23] == 8'hFF) && (b[22:0] != 23'd0);

                    // Reset output in case of early reset
                    z <= 32'd0;

                    counter <= counter + 3'd1;
                end

                3'd1: begin
                    // Prepare mantissas with implicit leading 1 if normalized
                    a_mantissa <= (a_exp == 8'd0) ? {1'b0, a_frac} : {1'b1, a_frac};
                    b_mantissa <= (b_exp == 8'd0) ? {1'b0, b_frac} : {1'b1, b_frac};

                    // Sign calculation
                    sign_res <= a_sign ^ b_sign;

                    // Exponent addition, adjust bias
                    // Handle subnormals by treating exponent as 1 if zero (as per IEEE standard for denormals)
                    // But here mantissa is without bias adjustment. We subtract bias directly.
                    // For subnormals exp=0 treated as 1 for exponent calculation.
                    exp_sum <= (a_exp == 8'd0 ? 1 : a_exp) + (b_exp == 8'd0 ? 1 : b_exp) - EXP_BIAS;

                    counter <= counter + 3'd1;
                end

                3'd2: begin
                    // Multiply mantissas (24x24 bits)
                    product <= a_mantissa * b_mantissa;
                    counter <= counter + 3'd1;
                end

                3'd3: begin
                    // Normalize the product:
                    // If product MSB=1 (bit 47), product >= 2, shift right and increment exponent
                    if (product[47]) begin
                        norm_mantissa <= product[47:24]; // top 24 bits after shift
                        norm_exponent <= exp_sum + 10'd1;
                        guard_bit <= product[23];
                        round_bit <= product[22];
                        sticky_bit <= |product[21:0];
                    end else begin
                        norm_mantissa <= product[46:23]; // no shift
                        norm_exponent <= exp_sum;
                        guard_bit <= product[22];
                        round_bit <= product[21];
                        sticky_bit <= |product[20:0];
                    end
                    counter <= counter + 3'd1;
                end

                3'd4: begin
                    // Round to nearest even
                    // Round up if guard_bit=1 and (round_bit=1 or sticky_bit=1 or LSB of mantissa=1)
                    if (guard_bit && (round_bit | sticky_bit | norm_mantissa[0]))
                        rounded_mantissa <= {1'b0, norm_mantissa} + 25'd1;
                    else
                        rounded_mantissa <= {1'b0, norm_mantissa};

                    // Initially copy exponent
                    rounded_exponent <= norm_exponent;
                    counter <= counter + 3'd1;
                end

                3'd5: begin
                    // Handle rounding overflow (mantissa overflow)
                    if (rounded_mantissa[24]) begin
                        // Mantissa overflowed, shift right and increase exponent
                        rounded_mantissa <= rounded_mantissa >> 1;
                        rounded_exponent <= rounded_exponent + 10'd1;
                    end

                    // Handle special cases and output assignment
                    if (a_nan || b_nan) begin
                        // Output quiet NaN: sign=0, exponent=all 1s, mantissa MSB=1
                        z <= {1'b0, 8'hFF, 1'b1, 22'd0};
                    end else if ((a_inf && b_zero) || (b_inf && a_zero)) begin
                        // Inf * zero = NaN
                        z <= {1'b0, 8'hFF, 1'b1, 22'd0};
                    end else if (a_inf || b_inf) begin
                        // Infinity result
                        z <= {sign_res, 8'hFF, 23'd0};
                    end else if (a_zero || b_zero) begin
                        // Zero result
                        z <= {sign_res, 31'd0};
                    end else if (rounded_exponent[7:0] >= 8'hFF) begin
                        // Overflow exponent => infinity
                        z <= {sign_res, 8'hFF, 23'd0};
                    end else if (rounded_exponent <= 10'd0) begin
                        // Underflow => zero (flush to zero)
                        z <= {sign_res, 31'd0};
                    end else begin
                        // Normal result
                        z <= {sign_res, rounded_exponent[7:0], rounded_mantissa[22:0]};
                    end

                    // Wrap counter to start new multiplication on next clock
                    counter <= 3'd0;
                end

                default: counter <= 3'd0;
            endcase
        end
    end

endmodule