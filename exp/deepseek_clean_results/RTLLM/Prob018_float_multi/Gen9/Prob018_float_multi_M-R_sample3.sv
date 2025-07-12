module float_multi(
    input clk,
    input rst,
    input [31:0] a,
    input [31:0] b,
    output reg [31:0] z
);

    // Pipeline registers
    reg [31:0] stage1_a, stage1_b;
    reg [22:0] stage2_a_mantissa, stage2_b_mantissa;
    reg [7:0] stage2_a_exp, stage2_b_exp;
    reg stage2_a_sign, stage2_b_sign;
    reg [47:0] stage3_product;
    reg [7:0] stage3_exp_sum;
    reg stage3_sign;
    reg [22:0] stage4_mantissa;
    reg [7:0] stage4_exponent;
    reg stage4_sign;

    // Special case detection (combinational)
    wire a_zero = (stage1_a[30:0] == 0);
    wire b_zero = (stage1_b[30:0] == 0);
    wire a_inf = (&stage1_a[30:23]) && (stage1_a[22:0] == 0);
    wire b_inf = (&stage1_b[30:23]) && (stage1_b[22:0] == 0);
    wire a_nan = (&stage1_a[30:23]) && (|stage1_a[22:0]);
    wire b_nan = (&stage1_b[30:23]) && (|stage1_b[22:0]);

    // Exponent sum calculation
    wire [8:0] exp_sum = {1'b0, stage2_a_exp} + {1'b0, stage2_b_exp} - 8'd127;

    // Rounding logic
    wire [23:0] rounded_mantissa;
    assign rounded_mantissa = stage3_product[47] ? 
                            {1'b1, stage3_product[46:24]} + {23'b0, stage3_product[23] & (stage3_product[22] | |stage3_product[21:0])} :
                            {1'b1, stage3_product[45:23]} + {23'b0, stage3_product[22] & (stage3_product[21] | |stage3_product[20:0])};

    // Final output selection
    wire [31:0] nan_out = 32'h7FC00000;
    wire [31:0] inf_out = {stage4_sign, 8'hFF, 23'b0};
    wire [31:0] zero_out = {stage4_sign, 31'b0};
    wire [31:0] normal_out = {stage4_sign, stage4_exponent, stage4_mantissa};

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            // Reset pipeline registers
            stage1_a <= 0;
            stage1_b <= 0;
            stage2_a_mantissa <= 0;
            stage2_b_mantissa <= 0;
            stage2_a_exp <= 0;
            stage2_b_exp <= 0;
            stage2_a_sign <= 0;
            stage2_b_sign <= 0;
            stage3_product <= 0;
            stage3_exp_sum <= 0;
            stage3_sign <= 0;
            stage4_mantissa <= 0;
            stage4_exponent <= 0;
            stage4_sign <= 0;
            z <= 0;
        end else begin
            // Pipeline stage 1: Input registration
            stage1_a <= a;
            stage1_b <= b;

            // Pipeline stage 2: Component extraction
            stage2_a_mantissa <= stage1_a[22:0];
            stage2_b_mantissa <= stage1_b[22:0];
            stage2_a_exp <= stage1_a[30:23];
            stage2_b_exp <= stage1_b[30:23];
            stage2_a_sign <= stage1_a[31];
            stage2_b_sign <= stage1_b[31];

            // Pipeline stage 3: Multiplication
            stage3_product <= {1'b1, stage2_a_mantissa} * {1'b1, stage2_b_mantissa};
            stage3_exp_sum <= exp_sum[7:0];
            stage3_sign <= stage2_a_sign ^ stage2_b_sign;

            // Pipeline stage 4: Normalization and rounding
            stage4_mantissa <= rounded_mantissa[22:0];
            stage4_exponent <= rounded_mantissa[23] ? stage3_exp_sum + 1 : stage3_exp_sum;
            stage4_sign <= stage3_sign;

            // Handle overflow from rounding
            if (rounded_mantissa[23]) begin
                stage4_mantissa <= rounded_mantissa[23:1];
                stage4_exponent <= stage3_exp_sum + 2;
            end

            // Final output stage
            if (a_nan || b_nan) z <= nan_out;
            else if ((a_inf || b_inf) && (a_zero || b_zero)) z <= nan_out;
            else if (a_inf || b_inf) z <= inf_out;
            else if (a_zero || b_zero) z <= zero_out;
            else if (&stage4_exponent || exp_sum[8]) z <= inf_out; // Overflow
            else if (stage4_exponent == 0) z <= zero_out; // Underflow
            else z <= normal_out;
        end
    end

endmodule