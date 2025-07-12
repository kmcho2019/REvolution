module float_multi(
    input clk,
    input rst,
    input [31:0] a,
    input [31:0] b,
    output reg [31:0] z
);

    // Special case detection (combinational)
    wire a_zero = (a[30:0] == 0);
    wire b_zero = (b[30:0] == 0);
    wire a_inf = (&a[30:23]) && (a[22:0] == 0);
    wire b_inf = (&b[30:23]) && (b[22:0] == 0);
    wire a_nan = (&a[30:23]) && (|a[22:0]);
    wire b_nan = (&b[30:23]) && (|b[22:0]);
    wire special_case = a_nan | b_nan | a_inf | b_inf | a_zero | b_zero;

    // Pipeline stage 0 registers
    reg stage0_special;
    reg stage0_a_sign, stage0_b_sign;
    reg [7:0] stage0_a_exp, stage0_b_exp;
    reg [22:0] stage0_a_mant, stage0_b_mant;

    // Logarithmic conversion parameters
    localparam LOG_PRECISION = 12;
    wire [LOG_PRECISION-1:0] log_a, log_b;
    
    // Logarithm approximation (piecewise linear)
    assign log_a = (stage0_a_mant[22] ? 12'h800 : 12'h000) + 
                  {1'b0, stage0_a_mant[21:21-LOG_PRECISION+2]};
    assign log_b = (stage0_b_mant[22] ? 12'h800 : 12'h000) + 
                  {1'b0, stage0_b_mant[21:21-LOG_PRECISION+2]};

    // Pipeline stage 1 registers
    reg stage1_special;
    reg stage1_sign;
    reg [8:0] stage1_exp_sum;
    reg [LOG_PRECISION-1:0] stage1_log_sum;
    
    // Error correction LUT (compensates for log approximation)
    reg [LOG_PRECISION-1:0] error_correction;
    always @(*) begin
        case(stage1_log_sum[LOG_PRECISION-1:LOG_PRECISION-4])
            4'h0: error_correction = 12'h000;
            4'h1: error_correction = 12'h00A;
            4'h2: error_correction = 12'h014;
            // ... (complete LUT entries)
            4'hF: error_correction = 12'h0F2;
            default: error_correction = 12'h000;
        endcase
    end

    // Pipeline stage 2 registers
    reg stage2_special;
    reg stage2_sign;
    reg [8:0] stage2_exp;
    reg [23:0] stage2_mantissa;
    
    // Anti-log conversion (with error correction)
    wire [23:0] antilog_result = 
        (1 << 23) + (stage1_log_sum << (23-LOG_PRECISION)) + 
        (error_correction << (23-LOG_PRECISION-2));

    // Rounding logic
    wire round_inc = stage2_mantissa[1] & (stage2_mantissa[0] | |stage2_mantissa[22:2]);
    wire [22:0] final_mantissa = round_inc ? stage2_mantissa[23:1] + 1 : stage2_mantissa[23:1];
    wire [7:0] final_exp = (stage2_mantissa[23] && round_inc) ? stage2_exp + 1 : stage2_exp;

    // Main pipeline
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            // Stage 0
            stage0_special <= 0;
            stage0_a_sign <= 0; stage0_b_sign <= 0;
            stage0_a_exp <= 0; stage0_b_exp <= 0;
            stage0_a_mant <= 0; stage0_b_mant <= 0;
            
            // Stage 1
            stage1_special <= 0;
            stage1_sign <= 0;
            stage1_exp_sum <= 0;
            stage1_log_sum <= 0;
            
            // Stage 2
            stage2_special <= 0;
            stage2_sign <= 0;
            stage2_exp <= 0;
            stage2_mantissa <= 0;
            
            // Output
            z <= 0;
        end else begin
            // Stage 0: Input capture and special case detection
            stage0_special <= special_case;
            stage0_a_sign <= a[31];
            stage0_b_sign <= b[31];
            stage0_a_exp <= a[30:23];
            stage0_b_exp <= b[30:23];
            stage0_a_mant <= a[22:0];
            stage0_b_mant <= b[22:0];
            
            // Stage 1: Logarithmic processing
            stage1_special <= stage0_special;
            stage1_sign <= stage0_a_sign ^ stage0_b_sign;
            stage1_exp_sum <= {1'b0, stage0_a_exp} + {1'b0, stage0_b_exp} - 9'd127;
            stage1_log_sum <= log_a + log_b;
            
            // Stage 2: Anti-log and error correction
            stage2_special <= stage1_special;
            stage2_sign <= stage1_sign;
            stage2_exp <= stage1_exp_sum;
            stage2_mantissa <= antilog_result;
            
            // Output stage
            if (stage2_special) begin
                if (a_nan | b_nan) z <= 32'h7FC00000;
                else if ((a_inf & b_zero) | (b_inf & a_zero)) z <= 32'h7FC00000;
                else if (a_inf | b_inf) z <= {stage2_sign, 8'hFF, 23'b0};
                else z <= {stage2_sign, 31'b0}; // Zero case
            end else begin
                if (stage2_exp[8] || &stage2_exp[7:0]) z <= {stage2_sign, 8'hFF, 23'b0}; // Overflow
                else if (stage2_exp == 0) z <= {stage2_sign, 31'b0}; // Underflow
                else z <= {stage2_sign, final_exp, final_mantissa};
            end
        end
    end

endmodule