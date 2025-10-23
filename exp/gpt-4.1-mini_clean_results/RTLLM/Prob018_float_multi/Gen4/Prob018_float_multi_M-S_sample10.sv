module float_multi(
    input clk,
    input rst,
    input [31:0] a,
    input [31:0] b,
    output reg [31:0] z
);
    localparam EXP_BIAS = 127;

    reg [1:0] counter;

    // Stage 0 registers
    reg a_sign, b_sign;
    reg [7:0] a_exp, b_exp;
    reg [23:0] a_mant, b_mant;

    // Stage 1 registers
    reg [49:0] product;      // 24x24 bits = 48 bits product, stored in 50 bits for alignment
    reg [9:0] exponent_sum;  // extended exponent for bias adjustment and overflow
    reg z_sign;

    // Stage 2 registers
    reg [49:0] norm_product;
    reg [9:0] norm_exponent;
    reg guard_bit, round_bit, sticky_bit;
    reg [23:0] z_mantissa;
    reg round_inc;

    // Special flags computed from inputs (combinational)
    wire a_zero = (a[30:23] == 8'd0) && (a[22:0] == 23'd0);
    wire b_zero = (b[30:23] == 8'd0) && (b[22:0] == 23'd0);

    wire a_inf  = (a[30:23] == 8'hFF) && (a[22:0] == 23'd0);
    wire b_inf  = (b[30:23] == 8'hFF) && (b[22:0] == 23'd0);

    wire a_nan  = (a[30:23] == 8'hFF) && (a[22:0] != 23'd0);
    wire b_nan  = (b[30:23] == 8'hFF) && (b[22:0] != 23'd0);

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            counter <= 2'd0;
            z <= 32'd0;
            a_sign <= 1'b0;
            b_sign <= 1'b0;
            a_exp <= 8'd0;
            b_exp <= 8'd0;
            a_mant <= 24'd0;
            b_mant <= 24'd0;
            product <= 50'd0;
            exponent_sum <= 10'd0;
            z_sign <= 1'b0;
            norm_product <= 50'd0;
            norm_exponent <= 10'd0;
            guard_bit <= 0;
            round_bit <= 0;
            sticky_bit <= 0;
            z_mantissa <= 24'd0;
            round_inc <= 1'b0;
        end else begin
            case(counter)
            2'd0: begin
                // Extract sign, exponent, mantissa with implicit leading 1 if normalized
                a_sign <= a[31];
                b_sign <= b[31];
                a_exp <= a[30:23];
                b_exp <= b[30:23];
                a_mant <= (a[30:23] == 8'd0) ? {1'b0, a[22:0]} : {1'b1, a[22:0]};
                b_mant <= (b[30:23] == 8'd0) ? {1'b0, b[22:0]} : {1'b1, b[22:0]};
                counter <= 2'd1;
            end
            2'd1: begin
                // Multiply mantissas and add exponents with bias correction
                product <= a_mant * b_mant;
                exponent_sum <= a_exp + b_exp - EXP_BIAS;
                z_sign <= a_sign ^ b_sign;
                counter <= 2'd2;
            end
            2'd2: begin
                // Normalize product if MSB at bit 47 set, else no shift
                if (product[47]) begin
                    norm_product <= product >> 1;
                    norm_exponent <= exponent_sum + 1;
                end else begin
                    norm_product <= product;
                    norm_exponent <= exponent_sum;
                end

                // Extract rounding bits for round to nearest even
                guard_bit <= (norm_product[23]);
                round_bit <= (norm_product[22]);
                sticky_bit <= |(norm_product[21:0]);

                // Mantissa bits with implicit leading 1 included
                z_mantissa <= norm_product[46:23];

                // Round increment decision (round to nearest even)
                round_inc <= guard_bit && (round_bit || sticky_bit || z_mantissa[0]);

                // Apply rounding
                if (round_inc) begin
                    reg [24:0] rounded_mant;
                    rounded_mant = {1'b0, z_mantissa} + 25'd1;
                    if (rounded_mant[24]) begin
                        // Mantissa overflow, shift right and increment exponent
                        z_mantissa <= rounded_mant[24:1];
                        norm_exponent <= norm_exponent + 1;
                    end else begin
                        z_mantissa <= rounded_mant[23:0];
                    end
                end

                // Handle special cases and final output assignment
                if (a_nan || b_nan) begin
                    // NaN: exponent=all ones, mantissa !=0 (quiet NaN leading bit 1)
                    z <= {1'b0, 8'hFF, 1'b1, 22'd0};
                end else if ((a_inf && b_zero) || (b_inf && a_zero)) begin
                    // Inf * 0 = NaN
                    z <= {1'b0, 8'hFF, 1'b1, 22'd0};
                end else if (a_inf || b_inf) begin
                    // Inf * nonzero = Inf
                    z <= {z_sign, 8'hFF, 23'd0};
                end else if (a_zero || b_zero) begin
                    // Zero * any = zero
                    z <= {z_sign, 31'd0};
                end else if (norm_exponent >= 8'hFF) begin
                    // Overflow to Inf
                    z <= {z_sign, 8'hFF, 23'd0};
                end else if (norm_exponent <= 0) begin
                    // Underflow to zero (no subnormal handling)
                    z <= {z_sign, 31'd0};
                end else begin
                    // Normalized result
                    z <= {z_sign, norm_exponent[7:0], z_mantissa[22:0]};
                end
                counter <= 2'd0;
            end
            endcase
        end
    end

endmodule