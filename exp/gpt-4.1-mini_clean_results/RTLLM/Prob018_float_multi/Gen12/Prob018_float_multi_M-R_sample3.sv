module float_multi (
    input           clk,
    input           rst,
    input  [31:0]   a,
    input  [31:0]   b,
    output reg [31:0] z
);
    localparam EXP_BIAS = 127;

    // Cycle counter for sequencing
    reg [2:0] counter;

    // Stage registers for input fields
    reg a_sign_r, b_sign_r;
    reg [7:0] a_exp_r, b_exp_r;
    reg [22:0] a_frac_r, b_frac_r;

    // Special flags latched
    reg a_zero_r, b_zero_r;
    reg a_inf_r, b_inf_r;
    reg a_nan_r, b_nan_r;

    // Mantissas with implicit bit
    reg [23:0] a_mant_r, b_mant_r;

    // Intermediate registered values after multiplication and exponent addition
    reg [47:0] product_r;
    reg [9:0]  exp_sum_r;
    reg        sign_r;

    // Special case registered
    reg special_nan_r, special_nan_out_r, special_inf_r, special_zero_r;

    // Normalized product and exponent registered
    reg [47:0] norm_product_r;
    reg [9:0]  norm_exp_r;

    // Mantissa and rounding bits registered
    reg [23:0] mantissa_r;
    reg guard_bit_r, round_bit_r, sticky_bit_r;

    // Rounded mantissa and adjusted exponent registered
    reg [24:0] mant_rounded_r;
    reg [9:0] exp_rounded_r;

    // Rounding increment logic combinational
    wire round_increment;

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

    // Assign rounding increment combinationally
    assign round_increment = guard_bit_r && (round_bit_r || sticky_bit_r || mantissa_r[0]);

    // Cycle counter to sequence pipeline
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            counter <= 3'd0;
            z <= 32'd0;

            // Reset all registers
            a_sign_r <= 1'b0; b_sign_r <= 1'b0;
            a_exp_r <= 8'd0; b_exp_r <= 8'd0;
            a_frac_r <= 23'd0; b_frac_r <= 23'd0;

            a_zero_r <= 1'b0; b_zero_r <= 1'b0;
            a_inf_r <= 1'b0; b_inf_r <= 1'b0;
            a_nan_r <= 1'b0; b_nan_r <= 1'b0;

            a_mant_r <= 24'd0; b_mant_r <= 24'd0;

            product_r <= 48'd0;
            exp_sum_r <= 10'd0;
            sign_r <= 1'b0;

            special_nan_r <= 1'b0; special_nan_out_r <= 1'b0; special_inf_r <= 1'b0; special_zero_r <= 1'b0;

            norm_product_r <= 48'd0;
            norm_exp_r <= 10'd0;

            mantissa_r <= 24'd0;
            guard_bit_r <= 1'b0; round_bit_r <= 1'b0; sticky_bit_r <= 1'b0;

            mant_rounded_r <= 25'd0;
            exp_rounded_r <= 10'd0;
        end else begin
            counter <= counter + 3'd1;

            case(counter)
                3'd0: begin
                    // Register inputs and detect special cases
                    a_sign_r <= a[31];
                    b_sign_r <= b[31];
                    a_exp_r  <= a[30:23];
                    b_exp_r  <= b[30:23];
                    a_frac_r <= a[22:0];
                    b_frac_r <= b[22:0];

                    a_zero_r <= is_zero(a[30:23], a[22:0]);
                    b_zero_r <= is_zero(b[30:23], b[22:0]);
                    a_inf_r  <= is_inf(a[30:23], a[22:0]);
                    b_inf_r  <= is_inf(b[30:23], b[22:0]);
                    a_nan_r  <= is_nan(a[30:23], a[22:0]);
                    b_nan_r  <= is_nan(b[30:23], b[22:0]);

                    a_mant_r <= (a[30:23] == 8'd0) ? {1'b0, a[22:0]} : {1'b1, a[22:0]};
                    b_mant_r <= (b[30:23] == 8'd0) ? {1'b0, b[22:0]} : {1'b1, b[22:0]};
                end

                3'd1: begin
                    // Perform multiplication and exponent addition
                    product_r <= a_mant_r * b_mant_r;

                    exp_sum_r <= a_exp_r + b_exp_r - EXP_BIAS;

                    sign_r <= a_sign_r ^ b_sign_r;

                    // Special cases
                    special_nan_r <= a_nan_r || b_nan_r;
                    special_nan_out_r <= (a_inf_r && b_zero_r) || (b_inf_r && a_zero_r);
                    special_inf_r <= (a_inf_r || b_inf_r) && !special_nan_out_r;
                    special_zero_r <= (a_zero_r || b_zero_r) && !special_nan_out_r && !special_inf_r;
                end

                3'd2: begin
                    // Normalization
                    if (product_r[47]) begin
                        norm_product_r <= product_r >> 1;
                        norm_exp_r <= exp_sum_r + 10'd1;
                    end else begin
                        norm_product_r <= product_r;
                        norm_exp_r <= exp_sum_r;
                    end

                    // Extract mantissa and rounding bits
                    mantissa_r <= norm_product_r[46:23];
                    guard_bit_r <= norm_product_r[23];
                    round_bit_r <= norm_product_r[22];
                    sticky_bit_r <= |norm_product_r[21:0];
                end

                3'd3: begin
                    // Rounding and exponent adjustment
                    mant_rounded_r <= {1'b0, mantissa_r} + round_increment;

                    if ({1'b0, mantissa_r} + round_increment[0] && ({1'b0, mantissa_r} + round_increment)[24]) begin
                        exp_rounded_r <= norm_exp_r + 10'd1;
                    end else begin
                        exp_rounded_r <= norm_exp_r;
                    end
                end

                3'd4: begin
                    // Final output assembly
                    // mant_rounded_r might have changed due to rounding overflow
                    // Adjust mantissa accordingly
                    if (mant_rounded_r[24]) begin
                        // Shift right mantissa by 1 if overflow and remove implicit bit
                        z <= {sign_r, exp_rounded_r[7:0], mant_rounded_r[23:1]};
                    end else begin
                        z <= {sign_r, exp_rounded_r[7:0], mant_rounded_r[22:0]};
                    end

                    // Handle special cases after all calculations
                    if (special_nan_r)
                        z <= {1'b0, 8'hFF, 1'b1, 22'd0}; // Quiet NaN
                    else if (special_nan_out_r)
                        z <= {1'b0, 8'hFF, 1'b1, 22'd0}; // NaN from Inf*0
                    else if (special_inf_r)
                        z <= {sign_r, 8'hFF, 23'd0};     // Infinity
                    else if (special_zero_r)
                        z <= {sign_r, 31'd0};            // Zero
                    else if (exp_rounded_r[9:8] != 2'b00)
                        z <= {sign_r, 8'hFF, 23'd0};     // Overflow to Inf
                    else if (exp_rounded_r[9:0] == 0)
                        z <= {sign_r, 31'd0};            // Underflow to zero (no subnormals)
                end

                default: ;
            endcase
        end
    end

endmodule