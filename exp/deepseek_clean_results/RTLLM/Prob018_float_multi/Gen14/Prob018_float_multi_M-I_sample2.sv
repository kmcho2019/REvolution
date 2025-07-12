module float_multi(
    input clk,
    input rst,
    input [31:0] a,
    input [31:0] b,
    output reg [31:0] z
);

    // Pipeline stage 1 registers
    reg [31:0] a_reg, b_reg;
    reg stage1_sign;
    reg [7:0] stage1_a_exp, stage1_b_exp;
    reg [23:0] stage1_a_mant, stage1_b_mant;
    reg stage1_a_zero, stage1_b_zero;
    reg stage1_a_inf, stage1_b_inf;
    reg stage1_a_nan, stage1_b_nan;
    
    // Pipeline stage 2 registers
    reg [47:0] stage2_product;
    reg [7:0] stage2_exponent;
    reg stage2_sign;
    reg stage2_zero, stage2_inf, stage2_nan;
    
    // Internal signals
    wire a_sign = a[31];
    wire b_sign = b[31];
    wire [7:0] a_exponent = a[30:23];
    wire [7:0] b_exponent = b[30:23];
    wire [22:0] a_mantissa = a[22:0];
    wire [22:0] b_mantissa = b[22:0];
    
    // Booth-encoded 24x24 multiplier
    function [47:0] booth_mult;
        input [23:0] a, b;
        reg [47:0] pp [0:11];
        reg [24:0] b_ext;
        integer i;
    begin
        b_ext = {b, 1'b0};
        pp[0] = 48'd0;
        
        for (i = 0; i < 12; i = i+1) begin
            case (b_ext[2*i+2:2*i])
                3'b001, 3'b010: pp[i+1] = pp[i] + (a << (2*i));
                3'b011:         pp[i+1] = pp[i] + (a << (2*i+1));
                3'b100:         pp[i+1] = pp[i] - (a << (2*i+1));
                3'b101, 3'b110: pp[i+1] = pp[i] - (a << (2*i));
                default:       pp[i+1] = pp[i];
            endcase
        end
        
        booth_mult = pp[12];
    end
    endfunction

    // Pipeline stage 1: Input processing
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            a_reg <= 0;
            b_reg <= 0;
            stage1_sign <= 0;
            stage1_a_exp <= 0;
            stage1_b_exp <= 0;
            stage1_a_mant <= 0;
            stage1_b_mant <= 0;
            stage1_a_zero <= 0;
            stage1_b_zero <= 0;
            stage1_a_inf <= 0;
            stage1_b_inf <= 0;
            stage1_a_nan <= 0;
            stage1_b_nan <= 0;
        end else begin
            a_reg <= a;
            b_reg <= b;
            stage1_sign <= a_sign ^ b_sign;
            
            // Normalized mantissas with implicit bit
            stage1_a_mant <= (a_exponent != 0) ? {1'b1, a_mantissa} : {1'b0, a_mantissa};
            stage1_b_mant <= (b_exponent != 0) ? {1'b1, b_mantissa} : {1'b0, b_mantissa};
            
            // Exponent processing
            stage1_a_exp <= a_exponent;
            stage1_b_exp <= b_exponent;
            
            // Special case detection
            stage1_a_zero <= (a_exponent == 0) && (a_mantissa == 0);
            stage1_b_zero <= (b_exponent == 0) && (b_mantissa == 0);
            stage1_a_inf <= (a_exponent == 8'hFF) && (a_mantissa == 0);
            stage1_b_inf <= (b_exponent == 8'hFF) && (b_mantissa == 0);
            stage1_a_nan <= (a_exponent == 8'hFF) && (a_mantissa != 0);
            stage1_b_nan <= (b_exponent == 8'hFF) && (b_mantissa != 0);
        end
    end

    // Pipeline stage 2: Multiplication and exponent calculation
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            stage2_product <= 0;
            stage2_exponent <= 0;
            stage2_sign <= 0;
            stage2_zero <= 0;
            stage2_inf <= 0;
            stage2_nan <= 0;
        end else begin
            // Booth-encoded multiplication
            stage2_product <= booth_mult(stage1_a_mant, stage1_b_mant);
            
            // Exponent calculation with bias adjustment
            stage2_exponent <= stage1_a_exp + stage1_b_exp - 8'd127;
            
            // Propagate special cases
            stage2_sign <= stage1_sign;
            stage2_zero <= stage1_a_zero || stage1_b_zero;
            stage2_inf <= stage1_a_inf || stage1_b_inf;
            stage2_nan <= stage1_a_nan || stage1_b_nan || 
                          (stage1_a_inf && stage1_b_zero) || 
                          (stage1_b_inf && stage1_a_zero);
        end
    end

    // Pipeline stage 3: Normalization, rounding, and output
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            z <= 0;
        end else begin
            if (stage2_nan) begin
                z <= 32'h7FC00000; // NaN
            end else if (stage2_inf) begin
                z <= {stage2_sign, 8'hFF, 23'b0}; // Infinity
            end else if (stage2_zero) begin
                z <= {stage2_sign, 31'b0}; // Zero
            end else begin
                // Normalization
                wire norm_shift = stage2_product[47];
                wire [22:0] mantissa = norm_shift ? stage2_product[46:24] : stage2_product[45:23];
                wire [7:0] exponent = norm_shift ? stage2_exponent + 1 : stage2_exponent;
                
                // Round to nearest even
                wire round_bit = norm_shift ? stage2_product[23] : stage2_product[22];
                wire sticky = |(norm_shift ? stage2_product[22:0] : stage2_product[21:0]);
                wire round_up = (round_bit & (mantissa[0] | sticky));
                wire [22:0] rounded_mantissa = mantissa + round_up;
                
                // Overflow check
                if (exponent >= 8'hFF) begin
                    z <= {stage2_sign, 8'hFF, 23'b0}; // Infinity
                end else begin
                    z <= {stage2_sign, exponent, rounded_mantissa};
                end
            end
        end
    end

endmodule