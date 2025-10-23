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
    
    // Pipeline stage 1 registers
    reg [23:0] a_mant, b_mant;
    reg [7:0] a_exp, b_exp;
    reg a_sig, b_sig;
    reg stage1_special;
    
    // Stage 1: Input preparation and special case detection
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            a_mant <= 0;
            b_mant <= 0;
            a_exp <= 0;
            b_exp <= 0;
            a_sig <= 0;
            b_sig <= 0;
            stage1_special <= 0;
        end else begin
            a_mant <= (|a[30:23]) ? {1'b1, a[22:0]} : {1'b0, a[22:0]};
            b_mant <= (|b[30:23]) ? {1'b1, b[22:0]} : {1'b0, b[22:0]};
            a_exp <= a[30:23];
            b_exp <= b[30:23];
            a_sig <= a[31];
            b_sig <= b[31];
            stage1_special <= special_case;
        end
    end
    
    // Signed-digit multiplication (combinational)
    wire [47:0] sd_product;
    signed_digit_multiplier mult_unit (
        .a(a_mant),
        .b(b_mant),
        .product(sd_product)
    );
    
    // Exponent calculation (combinational)
    wire [8:0] exp_sum = {1'b0, a_exp} + {1'b0, b_exp} - 9'd127;
    
    // Pipeline stage 2 registers
    reg [47:0] stage2_product;
    reg [8:0] stage2_exp;
    reg stage2_sign;
    reg stage2_special;
    
    // Stage 2: Multiplication and exponent sum
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            stage2_product <= 0;
            stage2_exp <= 0;
            stage2_sign <= 0;
            stage2_special <= 0;
        end else begin
            stage2_product <= sd_product;
            stage2_exp <= exp_sum;
            stage2_sign <= a_sig ^ b_sig;
            stage2_special <= stage1_special;
        end
    end
    
    // Dual-path normalization (combinational)
    wire [23:0] norm0_mant = stage2_product[46:23]; // No shift needed
    wire [8:0] norm0_exp = stage2_exp;
    
    wire [23:0] norm1_mant = stage2_product[47:24]; // Shift right by 1
    wire [8:0] norm1_exp = stage2_exp + 1;
    
    wire need_shift = stage2_product[47];
    wire [23:0] selected_mant = need_shift ? norm1_mant : norm0_mant;
    wire [8:0] selected_exp = need_shift ? norm1_exp : norm0_exp;
    
    // Rounding logic (combinational)
    wire guard = stage2_product[22];
    wire round = stage2_product[21];
    wire sticky = |stage2_product[20:0];
    wire round_up = guard & (round | sticky | selected_mant[0]);
    wire [23:0] rounded_mant = selected_mant + round_up;
    wire [8:0] final_exp = (&selected_mant & round_up) ? selected_exp + 1 : selected_exp;
    
    // Output selection
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            z <= 0;
        end else if (stage2_special) begin
            // Handle special cases
            if (a_nan | b_nan) begin
                z <= 32'h7FC00000; // Canonical NaN
            end else if ((a_inf & b_zero) | (b_inf & a_zero)) begin
                z <= 32'h7FC00000; // NaN for 0*inf
            end else if (a_inf | b_inf) begin
                z <= {stage2_sign, 8'hFF, 23'b0}; // Signed infinity
            end else begin // a_zero | b_zero
                z <= {stage2_sign, 31'b0}; // Signed zero
            end
        end else begin
            // Normal case
            if (final_exp[8] | &final_exp[7:0]) begin // Overflow
                z <= {stage2_sign, 8'hFF, 23'b0};
            end else if (final_exp == 0) begin // Underflow
                z <= {stage2_sign, 31'b0};
            end else begin
                z <= {stage2_sign, final_exp[7:0], rounded_mant[22:0]};
            end
        end
    end

endmodule

// Signed-digit multiplier module
module signed_digit_multiplier(
    input [23:0] a,
    input [23:0] b,
    output [47:0] product
);
    // Implementation of signed-digit multiplication
    // This would typically use Booth encoding or similar techniques
    // Simplified for brevity - actual implementation would have more stages
    wire [47:0] pp0 = a[0] ? {{24{b[23]}}, b} : 0;
    wire [47:0] pp1 = a[1] ? {{23{b[23]}}, b, 1'b0} : 0;
    // ... generate all partial products
    wire [47:0] pp23 = a[23] ? {b, 23'b0} : 0;
    
    // Wallace tree reduction
    // Multiple levels of carry-save adders
    // Final CPA
    assign product = pp0 + pp1 + ... + pp23;
endmodule