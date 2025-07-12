module float_multi(
    input clk,
    input rst,
    input [31:0] a,
    input [31:0] b,
    output reg [31:0] z
);

    // Extract sign, exponent, fraction fields
    wire a_sign = a[31];
    wire b_sign = b[31];
    wire [7:0] a_exp = a[30:23];
    wire [7:0] b_exp = b[30:23];
    wire [22:0] a_frac = a[22:0];
    wire [22:0] b_frac = b[22:0];

    localparam EXP_BIAS = 127;

    // Identify special cases
    wire a_zero = (a_exp == 8'd0) && (a_frac == 23'd0);
    wire b_zero = (b_exp == 8'd0) && (b_frac == 23'd0);

    wire a_inf = (a_exp == 8'hFF) && (a_frac == 23'd0);
    wire b_inf = (b_exp == 8'hFF) && (b_frac == 23'd0);

    wire a_nan = (a_exp == 8'hFF) && (a_frac != 23'd0);
    wire b_nan = (b_exp == 8'hFF) && (b_frac != 23'd0);

    // Mantissas with implicit leading 1 for normalized, else zero for zero/denormals
    wire [23:0] a_mant = (a_exp == 8'd0) ? {1'b0, a_frac} : {1'b1, a_frac};
    wire [23:0] b_mant = (b_exp == 8'd0) ? {1'b0, b_frac} : {1'b1, b_frac};

    // Internal regs for computation
    reg [47:0] product;
    reg [9:0] exp_sum;
    reg sign_res;

    reg [23:0] norm_mant;
    reg [9:0] norm_exp;
    reg guard_bit, round_bit, sticky_bit;

    reg [23:0] mant_rounded;
    reg [9:0] exp_rounded;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            z <= 32'd0;
        end else begin
            sign_res <= a_sign ^ b_sign;

            // Handle special cases
            if (a_nan || b_nan) begin
                // Output quiet NaN
                z <= {1'b0, 8'hFF, 1'b1, 22'd0};
            end else if ((a_inf && b_zero) || (b_inf && a_zero)) begin
                // Inf * 0 = NaN
                z <= {1'b0, 8'hFF, 1'b1, 22'd0};
            end else if (a_inf || b_inf) begin
                // Inf * normal = Inf
                z <= {sign_res, 8'hFF, 23'd0};
            end else if (a_zero || b_zero) begin
                // Zero * anything = zero
                z <= {sign_res, 31'd0};
            end else begin
                // Normal multiply
                product <= a_mant * b_mant;
                exp_sum <= a_exp + b_exp - EXP_BIAS;

                // Normalize
                if (product[47]) begin
                    product <= product >> 1;
                    exp_sum <= exp_sum + 1;
                end

                norm_mant <= product[46:23];
                guard_bit <= product[22];
                round_bit <= product[21];
                sticky_bit <= |product[20:0];
                norm_exp <= exp_sum;

                // Round to nearest even
                if (guard_bit && (round_bit | sticky_bit | norm_mant[0])) begin
                    mant_rounded <= norm_mant + 1'b1;
                    exp_rounded <= norm_exp;
                    if (mant_rounded == 24'h1000000) begin
                        mant_rounded <= mant_rounded >> 1;
                        exp_rounded <= exp_rounded + 1;
                    end
                end else begin
                    mant_rounded <= norm_mant;
                    exp_rounded <= norm_exp;
                end

                // Handle overflow and underflow
                if (exp_rounded >= 10'd255) begin
                    z <= {sign_res, 8'hFF, 23'd0}; // Inf
                end else if (exp_rounded <= 0) begin
                    z <= {sign_res, 31'd0}; // Zero
                end else begin
                    z <= {sign_res, exp_rounded[7:0], mant_rounded[22:0]};
                end
            end
        end
    end

endmodule