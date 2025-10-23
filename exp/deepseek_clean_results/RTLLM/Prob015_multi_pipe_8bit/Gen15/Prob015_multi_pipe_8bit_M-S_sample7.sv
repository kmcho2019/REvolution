module multi_pipe_8bit (
    input wire clk,
    input wire rst_n,
    input wire mul_en_in,
    input wire [7:0] mul_a,
    input wire [7:0] mul_b,
    output reg mul_en_out,
    output reg [15:0] mul_out
);

    // Pipeline stage 1 registers (input)
    reg [7:0] mul_a_reg, mul_b_reg;
    reg en_reg1;
    
    // Pipeline stage 2 registers (partial products)
    reg [15:0] pp0_reg, pp1_reg, pp2_reg, pp3_reg;
    reg [15:0] pp4_reg, pp5_reg, pp6_reg, pp7_reg;
    reg en_reg2;
    
    // Pipeline stage 3 registers (final sum)
    reg [15:0] sum_reg;
    reg en_reg3;
    
    // Partial products generation
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            // Reset all registers
            mul_a_reg <= 8'b0;
            mul_b_reg <= 8'b0;
            pp0_reg <= 16'b0;
            pp1_reg <= 16'b0;
            pp2_reg <= 16'b0;
            pp3_reg <= 16'b0;
            pp4_reg <= 16'b0;
            pp5_reg <= 16'b0;
            pp6_reg <= 16'b0;
            pp7_reg <= 16'b0;
            sum_reg <= 16'b0;
            
            // Enable shift register
            en_reg1 <= 1'b0;
            en_reg2 <= 1'b0;
            en_reg3 <= 1'b0;
        end else begin
            // Stage 1: Input registration
            mul_a_reg <= mul_a;
            mul_b_reg <= mul_b;
            en_reg1 <= mul_en_in;
            
            // Stage 2: Partial product registration
            pp0_reg <= mul_b_reg[0] ? {8'b0, mul_a_reg} : 16'b0;
            pp1_reg <= mul_b_reg[1] ? {7'b0, mul_a_reg, 1'b0} : 16'b0;
            pp2_reg <= mul_b_reg[2] ? {6'b0, mul_a_reg, 2'b0} : 16'b0;
            pp3_reg <= mul_b_reg[3] ? {5'b0, mul_a_reg, 3'b0} : 16'b0;
            pp4_reg <= mul_b_reg[4] ? {4'b0, mul_a_reg, 4'b0} : 16'b0;
            pp5_reg <= mul_b_reg[5] ? {3'b0, mul_a_reg, 5'b0} : 16'b0;
            pp6_reg <= mul_b_reg[6] ? {2'b0, mul_a_reg, 6'b0} : 16'b0;
            pp7_reg <= mul_b_reg[7] ? {1'b0, mul_a_reg, 7'b0} : 16'b0;
            en_reg2 <= en_reg1;
            
            // Stage 3: Final sum registration
            sum_reg <= pp0_reg + pp1_reg + pp2_reg + pp3_reg + 
                      pp4_reg + pp5_reg + pp6_reg + pp7_reg;
            en_reg3 <= en_reg2;
        end
    end
    
    // Output assignment
    always @(*) begin
        mul_en_out = en_reg3;
        mul_out = sum_reg;
    end

endmodule