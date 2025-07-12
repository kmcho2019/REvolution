module float_multi (
    input               clk,
    input               rst,        // synchronous active high reset
    input       [31:0]  a,
    input       [31:0]  b,
    output reg  [31:0]  z
);

    localparam EXP_BIAS = 127;

    // Internal registers and wires
    reg [2:0] counter;            // cycle counter: 0..4

    // Extracted inputs
    reg         a_sign, b_sign;
    reg [7:0]   a_exp, b_exp;
    reg [22:0]  a_frac, b_frac;

    // Flags for special cases
    reg a_zero, b_zero, a_inf, b_inf, a_nan, b_nan;

    // Mantissas with hidden bit (24 bits)
    reg [23:0]  a_mantissa, b_mantissa;

    // Sign and exponent sum
    reg         result_sign;
    reg [8:0]   exponent_sum; // 9 bits to hold sum after bias subtraction safely

    // Partial products for pipelined multiplication
    reg [11:0]  a_hi, a_lo;    // split a_mantissa into 12-bit halves
    reg [11:0]  b_hi, b_lo;    // split b_mantissa into 12-bit halves

    reg [23:0]  mul_high;      // partial mul: a_hi * b_hi -> 24 bits
    reg [23:0]  mul_mid1;      // partial mul: a_hi * b_lo -> 24 bits
    reg [23:0]  mul_mid2;      // partial mul: a_lo * b_hi -> 24 bits
    reg [23:0]  mul_low;       // partial mul: a_lo * b_lo -> 24 bits

    reg [47:0]  product;       // final assembled product 48-bit

    // Normalization signals
    reg [7:0]   final_exp;
    reg [23:0]  norm_mantissa;   // normalized mantissa including implicit 1

    reg         guard_bit, round_bit, sticky_bit;

    // Rounded mantissa intermediate
    reg [24:0]  mantissa_25;
    reg         round_increment;

    // Internal signals for rounding
    wire [23:0] mantissa_round_in;

    // State machine and pipeline stages
    always @(posedge clk) begin
        if (rst) begin
            counter <= 3'd0;
            z <= 32'd0;
            // Clear internal regs
            a_sign <= 1'b0; b_sign <= 1'b0;
            a_exp <= 8'd0; b_exp <= 8'd0;
            a_frac <= 23'd0; b_frac <= 23'd0;
            a_mantissa <= 24'd0; b_mantissa <= 24'd0;

            a_zero <= 1'b0; b_zero <= 1'b0;
            a_inf <= 1'b0; b_inf <= 1'b0;
            a_nan <= 1'b0; b_nan <= 1'b0;

            result_sign <= 1'b0;
            exponent_sum <= 9'd0;

            a_hi <= 12'd0; a_lo <= 12'd0;
            b_hi <= 12'd0; b_lo <= 12'd0;

            mul_high <= 24'd0;
            mul_mid1 <= 24'd0;
            mul_mid2 <= 24'd0;
            mul_low <= 24'd0;

            product <= 48'd0;

            final_exp <= 8'd0;
            norm_mantissa <= 24'd0;

            guard_bit <= 1'b0;
            round_bit <= 1'b0;
            sticky_bit <= 1'b0;

            mantissa_25 <= 25'd0;
            round_increment <= 1'b0;
        end else begin
            case (counter)
                3'd0: begin
                    // Capture inputs and decode special cases
                    a_sign <= a[31];
                    b_sign <= b[31];
                    a_exp <= a[30:23];
                    b_exp <= b[30:23];
                    a_frac <= a[22:0];
                    b_frac <= b[22:0];

                    a_zero <= (a[30:23] == 8'd0) && (a[22:0] == 23'd0);
                    b_zero <= (b[30:23] == 8'd0) && (b[22:0] == 23'd0);

                    a_inf <= (a[30:23] == 8'hFF) && (a[22:0] == 23'd0);
                    b_inf <= (b[30:23] == 8'hFF) && (b[22:0] == 23'd0);

                    a_nan <= (a[30:23] == 8'hFF) && (a[22:0] != 23'd0);
                    b_nan <= (b[30:23] == 8'hFF) && (b[22:0] != 23'd0);

                    // Prepare mantissas with hidden bit
                    // Denormals: leading zero, Normal: leading 1 implicit
                    a_mantissa <= (a[30:23] == 8'd0) ? {1'b0, a[22:0]} : {1'b1, a[22:0]};
                    b_mantissa <= (b[30:23] == 8'd0) ? {1'b0, b[22:0]} : {1'b1, b[22:0]};

                    result_sign <= a[31] ^ b[31];

                    // Pre-split mantissas into high and low 12 bits for partial product
                    a_hi <= (a[30:23] == 8'd0) ? 12'd0 : a_mantissa[23:12];
                    a_lo <= (a[30:23] == 8'd0) ? 12'd0 : a_mantissa[11:0];
                    b_hi <= (b[30:23] == 8'd0) ? 12'd0 : b_mantissa[23:12];
                    b_lo <= (b[30:23] == 8'd0) ? 12'd0 : b_mantissa[11:0];

                    exponent_sum <= a_exp + b_exp - EXP_BIAS;

                    counter <= 3'd1;
                end

                3'd1: begin
                    // Early special case check: if NaN or Inf or zero inputs,
                    // skip multiplication by setting product=0 and jump ahead later
                    if (a_nan || b_nan || a_inf || b_inf || a_zero || b_zero) begin
                        mul_high <= 24'd0;
                        mul_mid1 <= 24'd0;
                        mul_mid2 <= 24'd0;
                        mul_low <= 24'd0;
                        product <= 48'd0;
                    end else begin
                        // Partial multiply: high halves only
                        mul_high <= a_hi * b_hi;
                    end

                    counter <= 3'd2;
                end

                3'd2: begin
                    if (a_nan || b_nan || a_inf || b_inf || a_zero || b_zero) begin
                        product <= 48'd0; // skip multiplication, handled later
                    end else begin
                        // Partial multiply: cross terms and low halves
                        mul_mid1 <= a_hi * b_lo;
                        mul_mid2 <= a_lo * b_hi;
                        mul_low <= a_lo * b_lo;

                        // Assemble final product:
                        // product = (mul_high << 24) + ((mul_mid1 + mul_mid2) << 12) + mul_low
                        // Use temporary regs to avoid long combinational chain:
                        reg [25:0] mid_sum;
                        mid_sum = mul_mid1 + mul_mid2;
                        product = ({mul_high,24'd0}) + ({mid_sum,12'd0}) + mul_low;
                    end
                    counter <= 3'd3;
                end

                3'd3: begin
                    // Normalization and rounding preps
                    if (a_nan || b_nan) begin
                        // No normalization needed for NaN
                        final_exp <= 8'hFF;
                        norm_mantissa <= 24'h400000; // Quiet NaN pattern (MSB mantissa bit =1)
                        guard_bit <= 1'b0;
                        round_bit <= 1'b0;
                        sticky_bit <= 1'b0;
                    end else if ((a_inf && b_zero) || (b_inf && a_zero)) begin
                        // Inf * 0 = NaN
                        final_exp <= 8'hFF;
                        norm_mantissa <= 24'h400000;
                        guard_bit <= 1'b0;
                        round_bit <= 1'b0;
                        sticky_bit <= 1'b0;
                    end else if (a_inf || b_inf) begin
                        // Infinity result
                        final_exp <= 8'hFF;
                        norm_mantissa <= 24'd0;
                        guard_bit <= 1'b0;
                        round_bit <= 1'b0;
                        sticky_bit <= 1'b0;
                    end else if (a_zero || b_zero) begin
                        // Zero result
                        final_exp <= 8'd0;
                        norm_mantissa <= 24'd0;
                        guard_bit <= 1'b0;
                        round_bit <= 1'b0;
                        sticky_bit <= 1'b0;
                    end else begin
                        // Normal multiplication case
                        // Normalize product:
                        // If MSB bit 47 = 1, shift mantissa = product[47:24], exponent+1
                        // else mantissa = product[46:23], exponent unchanged
                        if (product[47]) begin
                            final_exp <= exponent_sum[7:0] + 1;
                            norm_mantissa <= product[47:24];
                            guard_bit <= product[23];
                            round_bit <= product[22];
                            sticky_bit <= |product[21:0];
                        end else begin
                            final_exp <= exponent_sum[7:0];
                            norm_mantissa <= product[46:23];
                            guard_bit <= product[22];
                            round_bit <= product[21];
                            sticky_bit <= |product[20:0];
                        end
                    end

                    counter <= 3'd4;
                end

                3'd4: begin
                    // Round-to-nearest even logic
                    round_increment <= guard_bit & (round_bit | sticky_bit | norm_mantissa[0]);
                    mantissa_25 <= {1'b0, norm_mantissa} + (round_increment ? 25'd1 : 25'd0);

                    // Check for mantissa overflow due to rounding
                    if (mantissa_25[24]) begin
                        // Mantissa overflow -> shift right by 1, increment exponent
                        final_exp <= final_exp + 1;
                        norm_mantissa <= mantissa_25[24:1];
                    end else begin
                        norm_mantissa <= mantissa_25[23:0];
                    end

                    // Now assemble final output with special case handling
                    if (a_nan || b_nan) begin
                        // Quiet NaN
                        z <= {1'b0, 8'hFF, 1'b1, 22'd0};
                    end else if ((a_inf && b_zero) || (b_inf && a_zero)) begin
                        // NaN due to Inf*0
                        z <= {1'b0, 8'hFF, 1'b1, 22'd0};
                    end else if (a_inf || b_inf) begin
                        // Infinity result
                        z <= {result_sign, 8'hFF, 23'd0};
                    end else if (a_zero || b_zero) begin
                        // Zero result
                        z <= {result_sign, 31'd0};
                    end else begin
                        // Normal case with exponent overflow/underflow check
                        if (final_exp >= 8'hFF) begin
                            // Overflow to infinity
                            z <= {result_sign, 8'hFF, 23'd0};
                        end else if (final_exp == 8'd0) begin
                            // Underflow to zero (flush)
                            z <= {result_sign, 31'd0};
                        end else begin
                            // Normal result
                            z <= {result_sign, final_exp, norm_mantissa[22:0]};
                        end
                    end

                    counter <= 3'd0; // ready for next input
                end

                default: begin
                    counter <= 3'd0;
                end
            endcase
        end
    end

endmodule