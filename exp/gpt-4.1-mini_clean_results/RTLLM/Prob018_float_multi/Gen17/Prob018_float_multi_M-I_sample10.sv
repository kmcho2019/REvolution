module float_multi (
    input           clk,
    input           rst,
    input  [31:0]   a,
    input  [31:0]   b,
    output reg [31:0] z
);

    localparam EXP_BIAS = 127;

    // Pipeline valid signal for gating registers and operations
    reg valid_s1, valid_s2, valid_s3, valid_s4, valid_s5;

    // Pipeline counter for debugging or optional (not strictly needed here)
    // reg [2:0] counter;

    // Stage 1: Extract fields
    reg        a_sign_s1, b_sign_s1;
    reg  [7:0] a_exp_s1, b_exp_s1;
    reg [22:0] a_frac_s1, b_frac_s1;
    reg        a_zero_s1, b_zero_s1;
    reg        a_inf_s1,  b_inf_s1;
    reg        a_nan_s1,  b_nan_s1;
    reg [23:0] a_mant_s1, b_mant_s1; // mantissas with hidden bit

    // Stage 2: Register inputs for multiplier and exponent sum, sign, special flags
    reg [23:0] a_mant_s2, b_mant_s2;
    reg [9:0]  exp_sum_s2;
    reg        sign_s2;
    reg        special_nan_s2;
    reg        special_nan_out_s2;
    reg        special_inf_s2;
    reg        special_zero_s2;

    // Stage 3: Multiplier output registered (48 bits)
    reg [47:0] product_s3;

    // Stage 4: Normalization, extract rounding bits, adjust exponent
    reg [47:0] norm_product_s4;
    reg [9:0]  norm_exp_s4;
    reg        sign_s4;
    reg        special_nan_s4;
    reg        special_nan_out_s4;
    reg        special_inf_s4;
    reg        special_zero_s4;

    reg        guard_bit_s4;
    reg        round_bit_s4;
    reg        sticky_bit_s4;
    reg [23:0] mantissa_s4;

    // Stage 5: Rounding and final exponent/mantissa adjustment
    reg        sign_s5;
    reg        special_nan_s5;
    reg        special_nan_out_s5;
    reg        special_inf_s5;
    reg        special_zero_s5;

    reg [24:0] mant_rounded_s5;
    reg [23:0] mant_rounded_final_s5;
    reg [9:0]  exp_rounded_s5;

    // Helper functions
    function is_zero(input [7:0] e, input [22:0] f);
        is_zero = (e == 8'd0) && (f == 23'd0);
    endfunction

    function is_inf(input [7:0] e, input [22:0] f);
        is_inf = (e == 8'hFF) && (f == 23'd0);
    endfunction

    function is_nan(input [7:0] e, input [22:0] f);
        is_nan = (e == 8'hFF) && (f != 23'd0);
    endfunction

    // Stage 1 input combinational calculations
    wire a_zero_w = is_zero(a[30:23], a[22:0]);
    wire b_zero_w = is_zero(b[30:23], b[22:0]);
    wire a_inf_w = is_inf(a[30:23], a[22:0]);
    wire b_inf_w = is_inf(b[30:23], b[22:0]);
    wire a_nan_w = is_nan(a[30:23], a[22:0]);
    wire b_nan_w = is_nan(b[30:23], b[22:0]);

    wire [23:0] a_mant_w = (a[30:23] == 8'd0) ? {1'b0, a[22:0]} : {1'b1, a[22:0]};
    wire [23:0] b_mant_w = (b[30:23] == 8'd0) ? {1'b0, b[22:0]} : {1'b1, b[22:0]};

    // Sticky bit calculation helper function: hierarchical OR reduction for bits [21:0]
    function sticky_bit_calc(input [21:0] bits);
        integer i;
        reg any_bit;
        begin
            any_bit = 1'b0;
            for (i = 0; i < 22; i = i + 1) begin
                any_bit = any_bit | bits[i];
            end
            sticky_bit_calc = any_bit;
        end
    endfunction

    // Register pipeline and logic with clock enables based on valid signal to reduce toggling
    always @(posedge clk) begin
        if (rst) begin
            // Reset all pipeline registers
            valid_s1 <= 1'b0;
            valid_s2 <= 1'b0;
            valid_s3 <= 1'b0;
            valid_s4 <= 1'b0;
            valid_s5 <= 1'b0;

            a_sign_s1 <= 1'b0; b_sign_s1 <= 1'b0;
            a_exp_s1 <= 8'd0; b_exp_s1 <= 8'd0;
            a_frac_s1 <= 23'd0; b_frac_s1 <= 23'd0;
            a_zero_s1 <= 1'b0; b_zero_s1 <= 1'b0;
            a_inf_s1 <= 1'b0; b_inf_s1 <= 1'b0;
            a_nan_s1 <= 1'b0; b_nan_s1 <= 1'b0;
            a_mant_s1 <= 24'd0; b_mant_s1 <= 24'd0;

            a_mant_s2 <= 24'd0; b_mant_s2 <= 24'd0;
            exp_sum_s2 <= 10'd0;
            sign_s2 <= 1'b0;
            special_nan_s2 <= 1'b0;
            special_nan_out_s2 <= 1'b0;
            special_inf_s2 <= 1'b0;
            special_zero_s2 <= 1'b0;

            product_s3 <= 48'd0;

            norm_product_s4 <= 48'd0;
            norm_exp_s4 <= 10'd0;
            sign_s4 <= 1'b0;
            special_nan_s4 <= 1'b0;
            special_nan_out_s4 <= 1'b0;
            special_inf_s4 <= 1'b0;
            special_zero_s4 <= 1'b0;

            guard_bit_s4 <= 1'b0;
            round_bit_s4 <= 1'b0;
            sticky_bit_s4 <= 1'b0;
            mantissa_s4 <= 24'd0;

            sign_s5 <= 1'b0;
            special_nan_s5 <= 1'b0;
            special_nan_out_s5 <= 1'b0;
            special_inf_s5 <= 1'b0;
            special_zero_s5 <= 1'b0;

            mant_rounded_s5 <= 25'd0;
            mant_rounded_final_s5 <= 24'd0;
            exp_rounded_s5 <= 10'd0;

            z <= 32'd0;

        end else begin
            // Stage 1: Extract inputs and special cases
            // Always valid on new inputs every clock cycle
            valid_s1 <= 1'b1;

            a_sign_s1 <= a[31];
            b_sign_s1 <= b[31];
            a_exp_s1 <= a[30:23];
            b_exp_s1 <= b[30:23];
            a_frac_s1 <= a[22:0];
            b_frac_s1 <= b[22:0];
            a_zero_s1 <= a_zero_w;
            b_zero_s1 <= b_zero_w;
            a_inf_s1 <= a_inf_w;
            b_inf_s1 <= b_inf_w;
            a_nan_s1 <= a_nan_w;
            b_nan_s1 <= b_nan_w;
            a_mant_s1 <= a_mant_w;
            b_mant_s1 <= b_mant_w;

            // Stage 2: Register inputs for multiplier and calculate exponent/sign and special flags
            if (valid_s1) begin
                valid_s2 <= 1'b1;
                a_mant_s2 <= a_mant_s1;
                b_mant_s2 <= b_mant_s1;

                exp_sum_s2 <= a_exp_s1 + b_exp_s1 - EXP_BIAS;
                sign_s2 <= a_sign_s1 ^ b_sign_s1;

                special_nan_s2 <= a_nan_s1 || b_nan_s1;
                special_nan_out_s2 <= (a_inf_s1 && b_zero_s1) || (b_inf_s1 && a_zero_s1);
                special_inf_s2 <= (a_inf_s1 || b_inf_s1) && !special_nan_out_s2;
                special_zero_s2 <= (a_zero_s1 || b_zero_s1) && !special_nan_out_s2 && !special_inf_s2;
            end else begin
                valid_s2 <= 1'b0;
            end

            // Stage 3: Multiply mantissas, registered output
            if (valid_s2) begin
                valid_s3 <= 1'b1;
                product_s3 <= a_mant_s2 * b_mant_s2;
            end else begin
                valid_s3 <= 1'b0;
                product_s3 <= 48'd0;
            end

            // Pass special flags and sign to next stage for consistent pipeline
            if (valid_s2) begin
                // sign_s2 and special flags passed next cycle to stage 4
                sign_s4 <= sign_s2;
                special_nan_s4 <= special_nan_s2;
                special_nan_out_s4 <= special_nan_out_s2;
                special_inf_s4 <= special_inf_s2;
                special_zero_s4 <= special_zero_s2;
            end else begin
                sign_s4 <= 1'b0;
                special_nan_s4 <= 1'b0;
                special_nan_out_s4 <= 1'b0;
                special_inf_s4 <= 1'b0;
                special_zero_s4 <= 1'b0;
            end

            // Stage 4: Normalize product, extract rounding bits, adjust exponent
            if (valid_s3) begin
                valid_s4 <= 1'b1;
                if (product_s3[47]) begin
                    norm_product_s4 <= product_s3 >> 1;
                    norm_exp_s4 <= exp_sum_s2 + 10'd1;
                end else begin
                    norm_product_s4 <= product_s3;
                    norm_exp_s4 <= exp_sum_s2;
                end

                // Extract mantissa bits [46:23]
                mantissa_s4 <= (product_s3[47]) ? (product_s3 >> 1)[46:23] : product_s3[46:23];

                // Extract rounding bits
                guard_bit_s4 <= (product_s3[47]) ? (product_s3 >> 1)[23] : product_s3[23];
                round_bit_s4 <= (product_s3[47]) ? (product_s3 >> 1)[22] : product_s3[22];

                // Sticky bit: hierarchical OR reduction of bits [21:0]
                sticky_bit_s4 <= sticky_bit_calc((product_s3[47]) ? (product_s3 >> 1)[21:0] : product_s3[21:0]);
            end else begin
                valid_s4 <= 1'b0;
                norm_product_s4 <= 48'd0;
                norm_exp_s4 <= 10'd0;
                mantissa_s4 <= 24'd0;
                guard_bit_s4 <= 1'b0;
                round_bit_s4 <= 1'b0;
                sticky_bit_s4 <= 1'b0;
            end

            // Pass sign and special flags to next stage
            if (valid_s4) begin
                valid_s5 <= 1'b1;
                sign_s5 <= sign_s4;
                special_nan_s5 <= special_nan_s4;
                special_nan_out_s5 <= special_nan_out_s4;
                special_inf_s5 <= special_inf_s4;
                special_zero_s5 <= special_zero_s4;
            end else begin
                valid_s5 <= 1'b0;
                sign_s5 <= 1'b0;
                special_nan_s5 <= 1'b0;
                special_nan_out_s5 <= 1'b0;
                special_inf_s5 <= 1'b0;
                special_zero_s5 <= 1'b0;
            end

            // Stage 5: Rounding and final adjustments
            if (valid_s5) begin
                // Round to nearest even
                if (guard_bit_s4 && (round_bit_s4 || sticky_bit_s4 || mantissa_s4[0]))
                    mant_rounded_s5 <= {1'b0, mantissa_s4} + 25'd1;
                else
                    mant_rounded_s5 <= {1'b0, mantissa_s4};

                // Handle mantissa overflow after rounding
                if (mant_rounded_s5[24]) begin
                    mant_rounded_final_s5 <= mant_rounded_s5[24:1];
                    exp_rounded_s5 <= norm_exp_s4 + 10'd1;
                end else begin
                    mant_rounded_final_s5 <= mant_rounded_s5[23:0];
                    exp_rounded_s5 <= norm_exp_s4;
                end

                // Output result, priority NaN > Inf > Zero > Overflow > Underflow > Normal
                if (special_nan_s5) begin
                    // canonical quiet NaN
                    z <= {1'b0, 8'hFF, 1'b1, 22'd0};
                end else if (special_nan_out_s5) begin
                    // NaN due to Inf*0
                    z <= {1'b0, 8'hFF, 1'b1, 22'd0};
                end else if (special_inf_s5) begin
                    // infinity
                    z <= {sign_s5, 8'hFF, 23'd0};
                end else if (special_zero_s5) begin
                    // zero
                    z <= {sign_s5, 31'd0};
                end else if (exp_rounded_s5[9:8] != 2'b00) begin
                    // Overflow to infinity
                    z <= {sign_s5, 8'hFF, 23'd0};
                end else if (exp_rounded_s5[7:0] == 8'd0) begin
                    // Underflow to zero (flush to zero, no gradual underflow)
                    z <= {sign_s5, 31'd0};
                end else begin
                    // Normal result
                    z <= {sign_s5, exp_rounded_s5[7:0], mant_rounded_final_s5[22:0]};
                end
            end else begin
                z <= 32'd0;
            end
        end
    end

endmodule