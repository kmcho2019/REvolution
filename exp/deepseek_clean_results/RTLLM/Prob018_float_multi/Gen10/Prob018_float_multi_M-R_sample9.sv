module float_multi(
    input clk,
    input rst,
    input [31:0] a,
    input [31:0] b,
    output reg [31:0] z
);

    // Pipeline stage wires
    wire [31:0] stage1_out;
    wire [47:0] stage2_product;
    wire [31:0] stage3_result;

    // Special case detection (combinational)
    wire a_sign = a[31];
    wire b_sign = b[31];
    wire [7:0] a_exp = a[30:23];
    wire [7:0] b_exp = b[30:23];
    wire [22:0] a_frac = a[22:0];
    wire [22:0] b_frac = b[22:0];

    wire a_zero = (a_exp == 0) && (a_frac == 0);
    wire b_zero = (b_exp == 0) && (b_frac == 0);
    wire a_inf = (a_exp == 8'hFF) && (a_frac == 0);
    wire b_inf = (b_exp == 8'hFF) && (b_frac == 0);
    wire a_nan = (a_exp == 8'hFF) && (a_frac != 0);
    wire b_nan = (b_exp == 8'hFF) && (b_frac != 0);
    
    wire special_case = a_nan | b_nan | a_inf | b_inf | a_zero | b_zero;
    wire [31:0] special_result = 
        (a_nan | b_nan | (a_inf & b_zero) | (a_zero & b_inf)) ? 
            {1'b0, 8'hFF, 1'b1, 22'b0} : // NaN
        (a_inf | b_inf) ? 
            {a_sign ^ b_sign, 8'hFF, 23'b0} : // Inf
            {a_sign ^ b_sign, 31'b0}; // Zero

    // Stage 1: Input preparation and special case handling
    assign stage1_out = special_case ? special_result : a;

    // Stage 2: Multiplication (registered)
    reg [23:0] a_mantissa, b_mantissa;
    reg [7:0] exp_sum;
    reg sign_reg;
    reg [31:0] stage1_reg;

    always @(posedge clk) begin
        if (rst) begin
            stage1_reg <= 0;
            a_mantissa <= 0;
            b_mantissa <= 0;
            exp_sum <= 0;
            sign_reg <= 0;
        end else begin
            stage1_reg <= stage1_out;
            
            if (!special_case) begin
                a_mantissa <= (a_exp == 0) ? {1'b0, a_frac} : {1'b1, a_frac};
                b_mantissa <= (b_exp == 0) ? {1'b0, b_frac} : {1'b1, b_frac};
                exp_sum <= a_exp + b_exp - 127;
                sign_reg <= a_sign ^ b_sign;
            end
        end
    end

    // Shared multiplier for partial products
    wire [15:0] a_upper = a_mantissa[23:8];
    wire [7:0] a_lower = a_mantissa[7:0];
    wire [15:0] b_upper = b_mantissa[23:8];
    wire [7:0] b_lower = b_mantissa[7:0];

    wire [23:0] pp_ul = a_upper * b_lower;
    wire [23:0] pp_lu = a_lower * b_upper;
    wire [15:0] pp_ll = a_lower * b_lower;
    wire [31:0] pp_uu = a_upper * b_upper;

    assign stage2_product = {pp_uu, 16'b0} + 
                           {8'b0, pp_ul, 8'b0} + 
                           {8'b0, pp_lu, 8'b0} + 
                           {16'b0, pp_ll};

    // Stage 3: Normalization and output (registered)
    reg [47:0] product_reg;
    reg [31:0] stage2_reg;

    always @(posedge clk) begin
        if (rst) begin
            product_reg <= 0;
            stage2_reg <= 0;
            z <= 0;
        end else begin
            stage2_reg <= stage1_reg;
            product_reg <= stage2_product;

            if (stage2_reg[31]) begin // Special case passthrough
                z <= stage2_reg;
            end else begin
                // Normalization and rounding
                if (product_reg[47]) begin
                    z <= {sign_reg, 
                         exp_sum + 1, 
                         product_reg[46:24] + (product_reg[23] & (product_reg[22] | |product_reg[21:0]))};
                end else begin
                    z <= {sign_reg, 
                         exp_sum, 
                         product_reg[45:23] + (product_reg[22] & (product_reg[21] | |product_reg[20:0]))};
                end
            end
        end
    end

endmodule