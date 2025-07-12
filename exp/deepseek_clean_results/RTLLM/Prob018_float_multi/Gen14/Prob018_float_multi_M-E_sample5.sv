module float_multi(
    input clk,
    input rst,
    input [31:0] a,
    input [31:0] b,
    output reg [31:0] z
);

    // Pipeline stage 1 registers (fetch and decode)
    reg [31:0] stage1_a, stage1_b;
    reg stage1_a_sign, stage1_b_sign;
    reg [7:0] stage1_a_exp, stage1_b_exp;
    reg [22:0] stage1_a_mant, stage1_b_mant;
    reg stage1_a_zero, stage1_b_zero;
    reg stage1_a_inf, stage1_b_inf;
    reg stage1_a_nan, stage1_b_nan;
    reg stage1_a_sub, stage1_b_sub;
    
    // Pipeline stage 2 registers (multiply)
    reg [47:0] stage2_product;
    reg [8:0] stage2_exp_sum;
    reg stage2_sign;
    reg stage2_zero, stage2_inf, stage2_nan;
    
    // Pipeline stage 3 registers (normalize and round)
    reg [31:0] stage3_result;
    
    // Booth encoding signals
    wire [25:0] booth_a = {2'b0, stage1_a_mant, 1'b0};
    wire [25:0] booth_b = {2'b0, stage1_b_mant, 1'b0};
    
    // Radix-4 Booth multiplier
    always @(posedge clk) begin
        if (rst) begin
            // Pipeline stage 1 reset
            stage1_a <= 0;
            stage1_b <= 0;
            stage1_a_sign <= 0;
            stage1_b_sign <= 0;
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
            stage1_a_sub <= 0;
            stage1_b_sub <= 0;
            
            // Pipeline stage 2 reset
            stage2_product <= 0;
            stage2_exp_sum <= 0;
            stage2_sign <= 0;
            stage2_zero <= 0;
            stage2_inf <= 0;
            stage2_nan <= 0;
            
            // Pipeline stage 3 reset
            stage3_result <= 0;
            z <= 0;
        end else begin
            // Pipeline stage 1: Input processing
            stage1_a <= a;
            stage1_b <= b;
            stage1_a_sign <= a[31];
            stage1_b_sign <= b[31];
            stage1_a_exp <= a[30:23];
            stage1_b_exp <= b[30:23];
            stage1_a_mant <= a[22:0];
            stage1_b_mant <= b[22:0];
            
            // Special case detection
            stage1_a_zero <= (a[30:23] == 0) && (a[22:0] == 0);
            stage1_b_zero <= (b[30:23] == 0) && (b[22:0] == 0);
            stage1_a_inf <= (a[30:23] == 8'hFF) && (a[22:0] == 0);
            stage1_b_inf <= (b[30:23] == 8'hFF) && (b[22:0] == 0);
            stage1_a_nan <= (a[30:23] == 8'hFF) && (a[22:0] != 0);
            stage1_b_nan <= (b[30:23] == 8'hFF) && (b[22:0] != 0);
            stage1_a_sub <= (a[30:23] == 0);
            stage1_b_sub <= (b[30:23] == 0);
            
            // Pipeline stage 2: Multiplication
            stage2_sign <= stage1_a_sign ^ stage1_b_sign;
            
            // Handle special cases
            stage2_zero <= stage1_a_zero || stage1_b_zero;
            stage2_inf <= stage1_a_inf || stage1_b_inf;
            stage2_nan <= stage1_a_nan || stage1_b_nan || 
                          (stage1_a_inf && stage1_b_zero) || 
                          (stage1_b_inf && stage1_a_zero);
            
            // Normal numbers processing
            if (!stage1_a_zero && !stage1_b_zero && 
                !stage1_a_inf && !stage1_b_inf && 
                !stage1_a_nan && !stage1_b_nan) begin
                
                // Add implicit bit
                reg [23:0] a_mant = stage1_a_sub ? {1'b0, stage1_a_mant} : {1'b1, stage1_a_mant};
                reg [23:0] b_mant = stage1_b_sub ? {1'b0, stage1_b_mant} : {1'b1, stage1_b_mant};
                
                // Radix-4 Booth multiplication
                reg [47:0] product = 0;
                for (integer i = 0; i < 12; i = i+1) begin
                    case (booth_b[2*i+2:2*i])
                        3'b000, 3'b111: product = product;
                        3'b001, 3'b010: product = product + (a_mant << (2*i));
                        3'b011: product = product + (a_mant << (2*i+1));
                        3'b100: product = product - (a_mant << (2*i+1));
                        3'b101, 3'b110: product = product - (a_mant << (2*i));
                    endcase
                end
                stage2_product <= product;
                
                // Exponent calculation
                reg [8:0] exp_a = stage1_a_sub ? 9'd1 : {1'b0, stage1_a_exp};
                reg [8:0] exp_b = stage1_b_sub ? 9'd1 : {1'b0, stage1_b_exp};
                stage2_exp_sum <= exp_a + exp_b - 9'd127;
            end
            
            // Pipeline stage 3: Normalization and rounding
            if (stage2_nan) begin
                stage3_result <= 32'h7FC00000; // NaN
            end else if (stage2_inf) begin
                stage3_result <= {stage2_sign, 8'hFF, 23'b0}; // Infinity
            end else if (stage2_zero) begin
                stage3_result <= {stage2_sign, 31'b0}; // Zero
            end else begin
                // Normalization
                reg [47:0] product = stage2_product;
                reg [8:0] exponent = stage2_exp_sum;
                reg norm_shift = product[47];
                
                // Rounding bits
                reg guard = norm_shift ? product[23] : product[22];
                reg round = norm_shift ? product[22] : product[21];
                reg sticky = norm_shift ? (|product[21:0]) : (|product[20:0]);
                
                // Select mantissa
                reg [22:0] mantissa = norm_shift ? product[46:24] : product[45:23];
                
                // Round up if needed
                if (guard && (round || sticky || mantissa[0])) begin
                    mantissa = mantissa + 1;
                    if (mantissa == 24'h1000000) begin // Carry out
                        mantissa = 23'h0;
                        exponent = exponent + 1;
                    end
                end
                
                // Check for overflow/underflow
                if (exponent[8] || (exponent[7:0] == 8'hFF)) begin
                    stage3_result <= {stage2_sign, 8'hFF, 23'b0}; // Infinity
                end else if (exponent[7:0] == 0) begin
                    stage3_result <= {stage2_sign, 31'b0}; // Zero (underflow)
                end else begin
                    stage3_result <= {stage2_sign, exponent[7:0], mantissa};
                end
            end
            
            // Final output
            z <= stage3_result;
        end
    end

endmodule