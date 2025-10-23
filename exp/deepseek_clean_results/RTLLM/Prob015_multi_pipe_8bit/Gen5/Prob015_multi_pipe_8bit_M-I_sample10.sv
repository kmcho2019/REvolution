module multi_pipe_8bit (
    input wire clk,
    input wire rst_n,
    input wire mul_en_in,
    input wire [7:0] mul_a,
    input wire [7:0] mul_b,
    output reg mul_en_out,
    output reg [15:0] mul_out
);

    // Pipeline stage 0 registers (input)
    reg [7:0] mul_a_reg0, mul_b_reg0;
    reg en_reg0;
    
    // Pipeline stage 1 registers (partial products)
    reg [15:0] pp0_1, pp2_3, pp4_5, pp6_7;
    reg en_reg1;
    
    // Pipeline stage 2 registers (first level sums)
    reg [15:0] sum01, sum23, sum45, sum67;
    reg en_reg2;
    
    // Pipeline stage 3 registers (second level sums)
    reg [15:0] sum0123, sum4567;
    reg en_reg3;
    
    // Final sum register
    reg [15:0] final_sum;
    reg en_reg4;
    
    // Generate partial products with enable gating
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            // Reset all registers
            mul_a_reg0 <= 8'b0;
            mul_b_reg0 <= 8'b0;
            en_reg0 <= 1'b0;
            pp0_1 <= 16'b0;
            pp2_3 <= 16'b0;
            pp4_5 <= 16'b0;
            pp6_7 <= 16'b0;
            en_reg1 <= 1'b0;
            sum01 <= 16'b0;
            sum23 <= 16'b0;
            sum45 <= 16'b0;
            sum67 <= 16'b0;
            en_reg2 <= 1'b0;
            sum0123 <= 16'b0;
            sum4567 <= 16'b0;
            en_reg3 <= 1'b0;
            final_sum <= 16'b0;
            en_reg4 <= 1'b0;
            mul_en_out <= 1'b0;
            mul_out <= 16'b0;
        end else begin
            // Stage 0: Input registration (clock gated)
            if (mul_en_in) begin
                mul_a_reg0 <= mul_a;
                mul_b_reg0 <= mul_b;
            end
            en_reg0 <= mul_en_in;
            
            // Stage 1: Partial product generation (clock gated)
            if (en_reg0) begin
                pp0_1 <= {8'b0, mul_a_reg0 & {8{mul_b_reg0[0]}}} + 
                        ({8'b0, mul_a_reg0 & {8{mul_b_reg0[1]}}} << 1);
                pp2_3 <= ({8'b0, mul_a_reg0 & {8{mul_b_reg0[2]}}} << 2) + 
                        ({8'b0, mul_a_reg0 & {8{mul_b_reg0[3]}}} << 3);
                pp4_5 <= ({8'b0, mul_a_reg0 & {8{mul_b_reg0[4]}}} << 4) + 
                        ({8'b0, mul_a_reg0 & {8{mul_b_reg0[5]}}} << 5);
                pp6_7 <= ({8'b0, mul_a_reg0 & {8{mul_b_reg0[6]}}} << 6) + 
                        ({8'b0, mul_a_reg0 & {8{mul_b_reg0[7]}}} << 7);
            end
            en_reg1 <= en_reg0;
            
            // Stage 2: First level sums (clock gated)
            if (en_reg1) begin
                sum01 <= pp0_1;
                sum23 <= pp2_3;
                sum45 <= pp4_5;
                sum67 <= pp6_7;
            end
            en_reg2 <= en_reg1;
            
            // Stage 3: Second level sums (clock gated)
            if (en_reg2) begin
                sum0123 <= sum01 + sum23;
                sum4567 <= sum45 + sum67;
            end
            en_reg3 <= en_reg2;
            
            // Stage 4: Final sum (clock gated)
            if (en_reg3) begin
                final_sum <= sum0123 + sum4567;
            end
            en_reg4 <= en_reg3;
            
            // Output assignment
            mul_en_out <= en_reg4;
            if (en_reg4) begin
                mul_out <= final_sum;
            end
        end
    end

endmodule