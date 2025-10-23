module float_multi(
    input           clk,
    input           rst,
    input  [31:0]   a,
    input  [31:0]   b,
    output reg [31:0] z
);
    localparam EXP_BIAS = 127;

    reg [2:0] counter;

    // Input stage registers
    reg a_sign, b_sign;
    reg [7:0] a_exp, b_exp;
    reg [23:0] a_mantissa, b_mantissa; // implicit leading bit included

    // Special case flags
    reg a_zero, b_zero, a_inf, b_inf, a_nan, b_nan;
    reg special_nan_out, special_inf_out, special_zero_out;

    // Stage 1 registers
    reg z_sign;
    reg [9:0] exponent_sum;   // 8 bits + bias subtraction + overflow room
    reg [47:0] product;       // 24x24 multiplication result

    // Stage 2 registers - normalization and rounding
    reg [47:0] product_norm;
    reg [9:0] exponent_norm;

    // Mantissa + rounding bits signals (combinational signals used in sequential block)
    wire guard_bit, round_bit;
    wire sticky_bit;
    wire [23:0] mantissa_field;

    reg [24:0] mantissa_rounded; // 1 bit overflow + 24 mantissa bits

    // Internal signals for rounding
    wire round_increment;
    wire mantissa_overflow;

    // Combinational extraction of rounding bits from normalized product:
    // We consider product_norm aligned so that MSB is bit 47 or shifted already.
    // Mantissa bits to keep: bits 46 down to 23 (24 bits)
    // guard_bit: bit 22
    // round_bit: bit 21
    // sticky_bit: OR reduction of bits 20 down to 0

    assign mantissa_field = product_norm[46:23];
    assign guard_bit    = product_norm[22];
    assign round_bit    = product_norm[21];
    assign sticky_bit   = |product_norm[20:0];

    assign round_increment = guard_bit & (round_bit | sticky_bit | mantissa_field[0]);

    assign mantissa_overflow = mantissa_rounded[24];

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            counter <= 3'd0;
            z <= 32'd0;

            // Reset registers
            a_sign <= 1'b0; b_sign <= 1'b0;
            a_exp <= 8'd0; b_exp <= 8'd0;
            a_mantissa <= 24'd0; b_mantissa <= 24'd0;

            a_zero <= 1'b0; b_zero <= 1'b0; a_inf <= 1'b0; b_inf <= 1'b0; a_nan <= 1'b0; b_nan <= 1'b0;
            special_nan_out <= 1'b0; special_inf_out <= 1'b0; special_zero_out <= 1'b0;

            z_sign <= 1'b0;
            exponent_sum <= 10'd0;
            product <= 48'd0;

            product_norm <= 48'd0;
            exponent_norm <= 10'd0;

            mantissa_rounded <= 25'd0;
            counter <= 3'd0;
        end else begin
            case (counter)
            3'd0: begin
                // Extract inputs fields
                a_sign <= a[31];
                b_sign <= b[31];
                a_exp <= a[30:23];
                b_exp <= b[30:23];

                // Set mantissas with implicit leading one if normalized
                a_mantissa <= (a[30:23] == 8'd0) ? {1'b0, a[22:0]} : {1'b1, a[22:0]};
                b_mantissa <= (b[30:23] == 8'd0) ? {1'b0, b[22:0]} : {1'b1, b[22:0]};

                // Detect special cases
                a_zero <= (a[30:23] == 8'd0) && (a[22:0] == 23'd0);
                b_zero <= (b[30:23] == 8'd0) && (b[22:0] == 23'd0);

                a_inf  <= (a[30:23] == 8'hFF) && (a[22:0] == 23'd0);
                b_inf  <= (b[30:23] == 8'hFF) && (b[22:0] == 23'd0);

                a_nan  <= (a[30:23] == 8'hFF) && (a[22:0] != 23'd0);
                b_nan  <= (b[30:23] == 8'hFF) && (b[22:0] != 23'd0);

                // Prepare special case outputs for next stage
                special_nan_out <= ((a_nan || b_nan) || ((a_inf && b_zero) || (b_inf && a_zero)));
                special_inf_out <= ((a_inf || b_inf) && !special_nan_out);
                special_zero_out <= ((a_zero || b_zero) && !special_nan_out && !special_inf_out);

                counter <= 3'd1;
            end
            3'd1: begin
                // Multiply mantissas (24x24)
                product <= a_mantissa * b_mantissa;

                // Exponent add and subtract bias (EXP_BIAS = 127)
                exponent_sum <= a_exp + b_exp - EXP_BIAS;

                // Compute sign as XOR
                z_sign <= a_sign ^ b_sign;

                counter <= 3'd2;
            end
            3'd2: begin
                // Normalization: if top bit product[47] == 1, shift right by 1 and increment exponent, else unchanged
                if (product[47]) begin
                    product_norm <= product >> 1;
                    exponent_norm <= exponent_sum + 1;
                end else begin
                    product_norm <= product;
                    exponent_norm <= exponent_sum;
                end

                // Round mantissa (to nearest even)
                // Compute mantissa_rounded combinationally here

                mantissa_rounded <= {1'b0, mantissa_field} + round_increment;

                // Adjust mantissa and exponent in case of rounding overflow
                if (mantissa_overflow) begin
                    // Overflow after rounding, shift mantissa right by 1 and increase exponent
                    z <= special_nan_out ? {1'b0, 8'hFF, 1'b1, 22'd0} : // quiet NaN
                         special_inf_out ? {z_sign, 8'hFF, 23'd0} :       // infinity
                         special_zero_out ? {z_sign, 31'd0} :             // zero
                         (exponent_norm + 1 >= 8'hFF) ? {z_sign, 8'hFF, 23'd0} : // overflow infinity
                         ((exponent_norm + 1) <= 0) ? {z_sign, 31'd0} :          // underflow zero
                         {z_sign, (exponent_norm + 1)[7:0], mantissa_rounded[24:2]}; // normalized result
                end else begin
                    // No mantissa overflow after rounding
                    z <= special_nan_out ? {1'b0, 8'hFF, 1'b1, 22'd0} :
                         special_inf_out ? {z_sign, 8'hFF, 23'd0} :
                         special_zero_out ? {z_sign, 31'd0} :
                         (exponent_norm >= 8'hFF) ? {z_sign, 8'hFF, 23'd0} :
                         (exponent_norm <= 0) ? {z_sign, 31'd0} :
                         {z_sign, exponent_norm[7:0], mantissa_rounded[23:1]};
                end

                counter <= 3'd0; // restart operation
            end
            default: counter <= 3'd0;
            endcase
        end
    end
endmodule