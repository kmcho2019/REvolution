module float_multi(
    input clk,
    input rst,
    input [31:0] a,
    input [31:0] b,
    output reg [31:0] z
);

    // Pipeline stages
    localparam STAGE_INPUT = 0;
    localparam STAGE_MUL1 = 1;
    localparam STAGE_MUL2 = 2;
    localparam STAGE_NORM = 3;
    localparam STAGE_OUT = 4;

    reg [2:0] pipeline_stage;
    
    // Input registers
    reg [31:0] a_reg, b_reg;
    reg a_sign, b_sign;
    reg [7:0] a_exp, b_exp;
    reg [23:0] a_mant, b_mant;
    
    // Special case detection (combinational)
    wire a_zero = (a_reg[30:0] == 0);
    wire b_zero = (b_reg[30:0] == 0);
    wire a_inf = (&a_reg[30:23]) && (a_reg[22:0] == 0);
    wire b_inf = (&b_reg[30:23]) && (b_reg[22:0] == 0);
    wire a_nan = (&a_reg[30:23]) && (|a_reg[22:0]);
    wire b_nan = (&b_reg[30:23]) && (|b_reg[22:0]);
    wire special_case = a_nan | b_nan | a_inf | b_inf | a_zero | b_zero;
    
    // Wallace tree pipeline registers
    reg [23:0] pp0, pp1, pp2, pp3; // Partial products
    reg [47:0] sum0, sum1; // Intermediate sums
    reg [47:0] product; // Final product
    
    // Normalization prediction
    reg will_normalize;
    reg [47:0] pre_norm_product;
    
    // Dual-path rounding
    reg [23:0] mantissa_n0, mantissa_n1; // Normalized with 0/1 shift
    reg [7:0] exp_n0, exp_n1;
    reg [23:0] rounded_mantissa;
    reg [7:0] rounded_exp;
    
    // Output construction
    wire [31:0] nan_out = 32'h7FC00000;
    wire [31:0] inf_out = {a_sign ^ b_sign, 8'hFF, 23'b0};
    wire [31:0] zero_out = {a_sign ^ b_sign, 31'b0};
    wire [31:0] normal_out = {a_sign ^ b_sign, rounded_exp, rounded_mantissa[22:0]};

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            pipeline_stage <= STAGE_INPUT;
            z <= 0;
        end else begin
            case (pipeline_stage)
                STAGE_INPUT: begin
                    // Register inputs and extract components
                    a_reg <= a;
                    b_reg <= b;
                    a_sign <= a[31];
                    b_sign <= b[31];
                    a_exp <= a[30:23];
                    b_exp <= b[30:23];
                    a_mant <= (|a[30:23]) ? {1'b1, a[22:0]} : {1'b0, a[22:0]};
                    b_mant <= (|b[30:23]) ? {1'b1, b[22:0]} : {1'b0, b[22:0]};
                    
                    // Generate first partial products
                    pp0 <= b_mant[0] ? a_mant : 0;
                    pp1 <= b_mant[1] ? a_mant : 0;
                    pp2 <= b_mant[2] ? a_mant : 0;
                    pp3 <= b_mant[3] ? a_mant : 0;
                    
                    // Pre-adjust exponent
                    will_normalize <= (a_exp == 0 || b_exp == 0) ? 0 : 1;
                    
                    pipeline_stage <= STAGE_MUL1;
                end
                
                STAGE_MUL1: begin
                    // Wallace tree stage 1
                    sum0 <= (pp0 << 0) + (pp1 << 1) + (pp2 << 2) + (pp3 << 3);
                    
                    // Generate next partial products
                    pp0 <= b_mant[4] ? a_mant : 0;
                    pp1 <= b_mant[5] ? a_mant : 0;
                    pp2 <= b_mant[6] ? a_mant : 0;
                    pp3 <= b_mant[7] ? a_mant : 0;
                    
                    pipeline_stage <= STAGE_MUL2;
                end
                
                STAGE_MUL2: begin
                    // Wallace tree stage 2
                    sum1 <= sum0 + (pp0 << 4) + (pp1 << 5) + (pp2 << 6) + (pp3 << 7);
                    
                    // Generate final partial products
                    pp0 <= b_mant[8] ? a_mant : 0;
                    pp1 <= b_mant[9] ? a_mant : 0;
                    pp2 <= b_mant[10] ? a_mant : 0;
                    pp3 <= b_mant[11] ? a_mant : 0;
                    
                    pipeline_stage <= STAGE_NORM;
                end
                
                STAGE_NORM: begin
                    // Final addition and normalization
                    product <= sum1 + (pp0 << 8) + (pp1 << 9) + (pp2 << 10) + (pp3 << 11);
                    
                    // Dual-path normalization
                    mantissa_n0 = product[46:23]; // No shift
                    mantissa_n1 = product[47:24]; // Shift by 1
                    
                    // Dual exponent paths
                    exp_n0 = a_exp + b_exp - 126; // -127 +1 for no shift
                    exp_n1 = a_exp + b_exp - 125; // -127 +2 for shift
                    
                    // Select based on prediction
                    if (will_normalize && product[47]) begin
                        rounded_mantissa <= mantissa_n1;
                        rounded_exp <= exp_n1;
                    end else begin
                        rounded_mantissa <= mantissa_n0;
                        rounded_exp <= exp_n0;
                    end
                    
                    pipeline_stage <= STAGE_OUT;
                end
                
                STAGE_OUT: begin
                    // Output selection with priority
                    if (a_nan | b_nan) z <= nan_out;
                    else if ((a_inf | b_inf) & (a_zero | b_zero)) z <= nan_out;
                    else if (a_inf | b_inf) z <= inf_out;
                    else if (a_zero | b_zero) z <= zero_out;
                    else if (rounded_exp[7] & |rounded_exp[6:0]) z <= inf_out; // Overflow
                    else if (rounded_exp == 0) z <= zero_out; // Underflow
                    else z <= normal_out;
                    
                    pipeline_stage <= STAGE_INPUT;
                end
            endcase
        end
    end

endmodule