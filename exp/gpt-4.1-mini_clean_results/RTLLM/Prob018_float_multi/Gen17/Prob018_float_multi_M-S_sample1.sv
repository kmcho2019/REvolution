module float_multi (
    input           clk,
    input           rst,
    input  [31:0]   a,
    input  [31:0]   b,
    output reg [31:0] z
);

    localparam EXP_BIAS = 127;
    localparam EXP_INF_NAN = 8'hFF;

    reg [2:0] counter;

    reg        a_sign, b_sign, z_sign;
    reg [9:0]  a_exp, b_exp, z_exp;      // 10 bits for overflow handling
    reg [23:0] a_mantissa, b_mantissa, z_mantissa; // 24-bit mantissa with hidden bit
    reg [49:0] product; // 24x24 multiplication result max 48 bits, use 50 for safety

    reg        a_zero, b_zero;
    reg        a_inf,  b_inf;
    reg        a_nan,  b_nan;

    reg        special_nan_out; // NaN from Inf*0 or similar
    reg        guard_bit, round_bit, sticky_bit;

    // Internal registers for normalized product and rounding
    reg [47:0] norm_product;
    reg [9:0]  norm_exp;

    // Functions to check special cases
    function is_zero(input [7:0] exp_, input [22:0] frac_);
        is_zero = (exp_ == 8'd0) && (frac_ == 23'd0);
    endfunction

    function is_inf(input [7:0] exp_, input [22:0] frac_);
        is_inf = (exp_ == 8'hFF) && (frac_ == 23'd0);
    endfunction

    function is_nan(input [7:0] exp_, input [22:0] frac_);
        is_nan = (exp_ == 8'hFF) && (frac_ != 23'd0);
    endfunction

    always @(posedge clk) begin
        if (rst) begin
            counter <= 3'd0;
            z <= 32'd0;

            a_sign <= 1'b0; b_sign <= 1'b0; z_sign <= 1'b0;
            a_exp <= 10'd0; b_exp <= 10'd0; z_exp <= 10'd0;
            a_mantissa <= 24'd0; b_mantissa <= 24'd0; z_mantissa <= 24'd0;
            product <= 50'd0;

            a_zero <= 1'b0; b_zero <= 1'b0;
            a_inf <= 1'b0;  b_inf <= 1'b0;
            a_nan <= 1'b0;  b_nan <= 1'b0;

            special_nan_out <= 1'b0;
            guard_bit <= 1'b0; round_bit <= 1'b0; sticky_bit <= 1'b0;

            norm_product <= 48'd0;
            norm_exp <= 10'd0;
        end else begin
            counter <= (counter == 3'd4) ? 3'd0 : counter + 3'd1;

            case (counter)
            3'd0: begin
                // Extract input sign, exponent, mantissa, and special cases
                a_sign <= a[31];
                b_sign <= b[31];

                a_exp <= {2'd0, a[30:23]}; // extend to 10 bits
                b_exp <= {2'd0, b[30:23]};

                a_zero <= is_zero(a[30:23], a[22:0]);
                b_zero <= is_zero(b[30:23], b[22:0]);

                a_inf <= is_inf(a[30:23], a[22:0]);
                b_inf <= is_inf(b[30:23], b[22:0]);

                a_nan <= is_nan(a[30:23], a[22:0]);
                b_nan <= is_nan(b[30:23], b[22:0]);

                // Mantissa with hidden bit (for normalized numbers)
                a_mantissa <= (a[30:23] == 8'd0) ? {1'b0, a[22:0]} : {1'b1, a[22:0]};
                b_mantissa <= (b[30:23] == 8'd0) ? {1'b0, b[22:0]} : {1'b1, b[22:0]};

                // Clear special_nan_out
                special_nan_out <= 1'b0;

                // Clear output registers, will update later
                z <= 32'd0;
                z_sign <= 1'b0;
                z_exp <= 10'd0;
                z_mantissa <= 24'd0;

                guard_bit <= 1'b0;
                round_bit <= 1'b0;
                sticky_bit <= 1'b0;

                norm_product <= 48'd0;
                norm_exp <= 10'd0;
                product <= 50'd0;
            end

            3'd1: begin
                // Handle special NaN output from Inf * 0 or 0 * Inf
                special_nan_out <= (a_inf && b_zero) || (b_inf && a_zero);

                // Compute sign
                z_sign <= a_sign ^ b_sign;

                // Compute exponent sum with bias adjustment
                z_exp <= a_exp + b_exp - EXP_BIAS;

                // Multiply mantissas (24-bit * 24-bit -> 48-bit product)
                product <= a_mantissa * b_mantissa;

                // Propagate special flags for output decision later
                // No changes here, rely on saved signals a_nan,b_nan,a_inf,b_inf,a_zero,b_zero
            end

            3'd2: begin
                // Normalize product and adjust exponent
                // product is 48 bits in bits [47:0], with possible leading one at bit 47 or bit 46

                if (product[47]) begin
                    norm_product <= product[47:0] >> 1;
                    norm_exp <= z_exp + 10'd1;
                end else begin
                    norm_product <= product[47:0];
                    norm_exp <= z_exp;
                end

                // Extract mantissa for output (bits 46 down to 23)
                z_mantissa <= norm_product[46:23];

                // Extract rounding bits
                guard_bit <= norm_product[22];
                round_bit <= norm_product[21];

                // Sticky bit: OR of bits [20:0]
                sticky_bit <= |norm_product[20:0];
            end

            3'd3: begin
                // Round mantissa using round to nearest even
                reg [24:0] mant_rounded; // 25 bits for overflow

                mant_rounded = {1'b0, z_mantissa} +
                    (guard_bit && (round_bit || sticky_bit || z_mantissa[0]) ? 25'd1 : 25'd0);

                // Check for mantissa overflow after rounding
                if (mant_rounded[24]) begin
                    z_mantissa <= mant_rounded[24:1];
                    norm_exp <= norm_exp + 10'd1;
                end else begin
                    z_mantissa <= mant_rounded[23:0];
                    norm_exp <= norm_exp;
                end
            end

            3'd4: begin
                // Final output generation and special cases handling

                // Priority: NaN > special_nan_out > Inf > Zero > Overflow > Underflow > Normal

                if (a_nan || b_nan) begin
                    // Input is NaN: produce quiet NaN canonical (sign=0)
                    z <= {1'b0, 8'hFF, 1'b1, 22'd0};
                end else if (special_nan_out) begin
                    // NaN due to Inf*0 or 0*Inf
                    z <= {1'b0, 8'hFF, 1'b1, 22'd0};
                end else if (a_inf || b_inf) begin
                    // Infinity case
                    z <= {z_sign, 8'hFF, 23'd0};
                end else if (a_zero || b_zero) begin
                    // Zero case
                    z <= {z_sign, 31'd0};
                end else if (norm_exp[9:8] != 2'b00) begin
                    // Overflow exponent => infinity
                    z <= {z_sign, 8'hFF, 23'd0};
                end else if (norm_exp[7:0] == 8'd0) begin
                    // Underflow => zero (no denormals)
                    z <= {z_sign, 31'd0};
                end else begin
                    // Normalized output
                    z <= {z_sign, norm_exp[7:0], z_mantissa[22:0]};
                end
            end

            default: begin
                // Idle or wait state; do nothing
            end
            endcase
        end
    end

endmodule