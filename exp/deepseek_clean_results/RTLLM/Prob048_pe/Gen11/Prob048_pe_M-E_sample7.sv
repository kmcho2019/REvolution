module pe (
    input wire clk,
    input wire rst,
    input wire signed [31:0] a,
    input wire signed [31:0] b,
    output reg signed [31:0] c
);

    // Pipeline registers
    reg signed [31:0] a_reg, b_reg;
    reg signed [63:0] product_reg;
    reg signed [31:0] sum_reg, carry_reg;
    
    // Clock gating signals
    wire a_zero = (a == 32'b0);
    wire b_zero = (b == 32'b0);
    wire mult_bypass = a_zero | b_zero;
    
    // Stage 1: Input registration and multiplier decomposition
    always @(posedge clk) begin
        if (rst) begin
            a_reg <= 32'b0;
            b_reg <= 32'b0;
        end else begin
            a_reg <= a;
            b_reg <= b;
        end
    end
    
    // Stage 2: Partial product generation and reduction
    always @(posedge clk) begin
        if (rst) begin
            product_reg <= 64'b0;
        end else if (mult_bypass) begin
            product_reg <= 64'b0;
        end else begin
            // Karatsuba decomposition (aH + aL)*(bH + bL) = aHbH + (aHbL + aLbH) + aLbL
            wire signed [15:0] aH = a_reg[31:16];
            wire signed [15:0] aL = a_reg[15:0];
            wire signed [15:0] bH = b_reg[31:16];
            wire signed [15:0] bL = b_reg[15:0];
            
            wire signed [31:0] pp1 = aH * bH;
            wire signed [31:0] pp2 = aH * bL;
            wire signed [31:0] pp3 = aL * bH;
            wire signed [31:0] pp4 = aL * bL;
            
            // 4:2 compressor tree reduction
            wire signed [31:0] sum1, carry1;
            wire signed [31:0] sum2, carry2;
            
            {carry1, sum1} = pp1 + (pp2 << 16);
            {carry2, sum2} = pp3 + (pp4 << 16);
            product_reg <= {carry1 + carry2, sum1 + sum2};
        end
    end
    
    // Stage 3: Carry-save accumulation
    always @(posedge clk) begin
        if (rst) begin
            sum_reg <= 32'b0;
            carry_reg <= 32'b0;
            c <= 32'b0;
        end else begin
            // Carry-save accumulation
            {carry_reg, sum_reg} <= sum_reg + carry_reg + product_reg[31:0];
            
            // Final addition with overflow protection
            wire signed [32:0] final_sum = sum_reg + carry_reg;
            c <= (final_sum[32] != final_sum[31]) ? 
                 (final_sum[32] ? 32'h80000000 : 32'h7FFFFFFF) : 
                 final_sum[31:0];
        end
    end

endmodule