module float_multi(
    input clk,
    input rst,
    input [31:0] a,
    input [31:0] b,
    output reg [31:0] z
);
    // Internal registers
    reg [2:0] counter;

    reg a_sign, b_sign, z_sign;
    reg [9:0] a_exponent, b_exponent, z_exponent;  // extended exponent width for addition
    reg [23:0] a_mantissa, b_mantissa, z_mantissa; // 24-bit mantissa including implicit bit
    reg [49:0] product;

    reg guard_bit, round_bit, sticky;

    // Special case flags
    reg a_is_nan, b_is_nan, a_is_inf, b_is_inf;
    reg a_is_zero, b_is_zero;

    // Temporary registers for normalization and rounding
    reg [24:0] norm_mantissa;  // one extra bit for possible normalization shift
    reg [9:0] norm_exponent;
    reg norm_shift;

    // Rounding logic signals
    reg round_increment;
    reg [24:0] rounded_mantissa;
    reg [9:0] rounded_exponent;

    // Bias
    localparam BIAS = 127;

    always @(posedge clk) begin
        if (rst) begin
            counter <= 3'd0;
            z <= 32'd0;
            // Reset internal registers as well
            a_sign <= 1'b0;
            b_sign <= 1'b0;
            z_sign <= 1'b0;
            a_exponent <= 10'd0;
            b_exponent <= 10'd0;
            z_exponent <= 10'd0;
            a_mantissa <= 24'd0;
            b_mantissa <= 24'd0;
            product <= 50'd0;
            guard_bit <= 1'b0;
            round_bit <= 1'b0;
            sticky <= 1'b0;
            a_is_nan <= 1'b0;
            b_is_nan <= 1'b0;
            a_is_inf <= 1'b0;
            b_is_inf <= 1'b0;
            a_is_zero <= 1'b0;
            b_is_zero <= 1'b0;
            norm_mantissa <= 25'd0;
            norm_exponent <= 10'd0;
            norm_shift <= 1'b0;
            round_increment <= 1'b0;
            rounded_mantissa <= 25'd0;
            rounded_exponent <= 10'd0;
        end else begin
            case(counter)
                3'd0: begin
                    // Idle or wait state, move to extraction next cycle
                    counter <= 3'd1;
                end

                3'd1: begin
                    // Extract sign, exponent, mantissa of inputs
                    a_sign <= a[31];
                    b_sign <= b[31];

                    a_exponent <= {2'b00, a[30:23]}; // extend to 10 bits for arithmetic
                    b_exponent <= {2'b00, b[30:23]};

                    // Check special cases for a
                    a_is_nan <= (a[30:23] == 8'hFF) && (|a[22:0]);
                    a_is_inf <= (a[30:23] == 8'hFF) && (~|a[22:0]);
                    a_is_zero <= (a[30:23] == 8'h00) && (~|a[22:0]);

                    // Check special cases for b
                    b_is_nan <= (b[30:23] == 8'hFF) && (|b[22:0]);
                    b_is_inf <= (b[30:23] == 8'hFF) && (~|b[22:0]);
                    b_is_zero <= (b[30:23] == 8'h00) && (~|b[22:0]);

                    // Prepare mantissas: if exponent != 0, implicit leading 1, else leading 0 (denormals)
                    a_mantissa <= (a[30:23] == 8'd0) ? {1'b0, a[22:0]} : {1'b1, a[22:0]};
                    b_mantissa <= (b[30:23] == 8'd0) ? {1'b0, b[22:0]} : {1'b1, b[22:0]};

                    counter <= 3'd2;
                end

                3'd2: begin
                    // Handle special cases NaN and Inf and Zero for quick output
                    if (a_is_nan || b_is_nan) begin
                        // If either is NaN, output NaN
                        z <= {1'b0, 8'hFF, 1'b1, 22'd0}; // quiet NaN
                        counter <= 3'd0;
                    end else if ((a_is_inf && b_is_zero) || (b_is_inf && a_is_zero)) begin
                        // Inf * Zero = NaN
                        z <= {1'b0, 8'hFF, 1'b1, 22'd0};
                        counter <= 3'd0;
                    end else if (a_is_inf || b_is_inf) begin
                        // Result infinity sign is xor of signs
                        z_sign <= a_sign ^ b_sign;
                        z <= {z_sign, 8'hFF, 23'd0};
                        counter <= 3'd0;
                    end else if (a_is_zero || b_is_zero) begin
                        // Result zero sign is xor of signs
                        z_sign <= a_sign ^ b_sign;
                        z <= {z_sign, 31'd0};
                        counter <= 3'd0;
                    end else begin
                        // Normal cases, proceed to multiplication
                        z_sign <= a_sign ^ b_sign;

                        // Exponent add, subtract bias(127)
                        z_exponent <= a_exponent + b_exponent - BIAS;

                        counter <= 3'd3;
                    end
                end

                3'd3: begin
                    // Multiply mantissas 24-bit * 24-bit = 48-bit product
                    // Use 50-bit product register to hold product aligned for normalization/rounding
                    // product[47:0] used; keep two extra bits for rounding

                    product <= a_mantissa * b_mantissa; // 24x24=48 bits, stored in lower bits of product

                    counter <= 3'd4;
                end

                3'd4: begin
                    // Normalize product:
                    // product is 48 bits: product[47:0]
                    // The leading bit of product is at bit 47 or bit 46 depending on inputs
                    // Check MSB at product[47]:
                    // If MSB=1, mantissa is already normalized, exponent + 1
                    // else shift mantissa left by 1 and decrement exponent

                    if (product[47]) begin
                        // MSB is 1, no shift needed
                        norm_mantissa <= product[47:23]; // take top 25 bits for rounding (1 hidden + 23 mantissa + 1 rounding bit)
                        norm_exponent <= z_exponent + 1;
                        norm_shift <= 1'b0;
                    end else begin
                        // MSB not set, shift left by 1 to normalize
                        norm_mantissa <= product[46:22];
                        norm_exponent <= z_exponent;
                        norm_shift <= 1'b1;
                    end

                    counter <= 3'd5;
                end

                3'd5: begin
                    // Extract rounding bits: guard, round, sticky
                    // norm_mantissa is 25 bits = [24]hidden + 23 mantissa + 1 rounding bit
                    // Actually we have 25 bits from product[47:23] or product[46:22],
                    // To extract rounding bits guard, round, sticky from product bits below 23:

                    // For guard: bit just below the mantissa LSB: product bit 22 or 21 depending on normalization
                    // round: bit below guard: 21 or 20
                    // sticky: OR of all bits below round bit: product[20:0]

                    // Compute indices of these bits:
                    integer guard_bit_index;
                    integer round_bit_index;
                    integer sticky_bit_index;

                    if (!norm_shift) begin
                        // no normalization shift, product aligned from bit 47
                        guard_bit_index = 22;
                        round_bit_index = 21;
                        sticky_bit_index = 0;
                    end else begin
                        // normalization shift by 1, product aligned from bit 46
                        guard_bit_index = 21;
                        round_bit_index = 20;
                        sticky_bit_index = 0;
                    end

                    guard_bit <= product[guard_bit_index];
                    round_bit <= product[round_bit_index];
                    // sticky bit is OR of all bits below round_bit_index
                    // in Verilog sum of bits from [sticky_bit_index:round_bit_index-1] for sticky
                    sticky <= |product[(round_bit_index-1):sticky_bit_index];

                    counter <= 3'd6;
                end

                3'd6: begin
                    // Rounding: round to nearest even (tie to even)
                    // round_increment is 1 if guard=1 and (round=1 or sticky=1 or LSB of mantissa is 1)
                    round_increment <= 0;
                    if (guard_bit) begin
                        if (round_bit | sticky)
                            round_increment <= 1'b1;
                        else if (norm_mantissa[0] == 1'b1)
                            round_increment <= 1'b1;
                    end

                    rounded_mantissa <= norm_mantissa + round_increment;

                    // Check if rounding caused mantissa overflow: if so, shift right mantissa and increment exponent
                    if (rounded_mantissa[24]) begin
                        rounded_mantissa <= rounded_mantissa >> 1;
                        rounded_exponent <= norm_exponent + 1;
                    end else begin
                        rounded_exponent <= norm_exponent;
                    end

                    counter <= 3'd7;
                end

                3'd7: begin
                    // Handle overflow and underflow
                    // If exponent >= 255 -> infinity
                    // If exponent <= 0 -> zero or subnormal

                    if (rounded_exponent >= 255) begin
                        // Overflow: output infinity
                        z <= {z_sign, 8'hFF, 23'd0};
                    end else if (rounded_exponent <= 0) begin
                        // Underflow: output zero (for simplicity no gradual underflow here)
                        z <= {z_sign, 31'd0};
                    end else begin
                        // Normal result
                        z <= {z_sign, rounded_exponent[7:0], rounded_mantissa[22:0]};
                    end

                    counter <= 3'd0; // done, wait for next inputs
                end

                default: counter <= 3'd0;
            endcase
        end
    end

endmodule