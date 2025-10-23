module multi_pipe_8bit (
    input wire clk,
    input wire rst_n,
    input wire mul_en_in,
    input wire [7:0] mul_a,
    input wire [7:0] mul_b,
    output reg mul_en_out,
    output reg [15:0] mul_out
);

    // Pipeline stage 1 registers
    reg [7:0] mul_a_reg, mul_b_reg;
    reg en_reg;
    
    // Pipeline stage 2 registers
    reg [15:0] product_reg;
    
    // Generate partial products and accumulate
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            // Reset all registers
            mul_a_reg <= 8'b0;
            mul_b_reg <= 8'b0;
            en_reg <= 1'b0;
            product_reg <= 16'b0;
            mul_en_out <= 1'b0;
            mul_out <= 16'b0;
        end else begin
            // Stage 1: Input registration and partial product calculation
            mul_a_reg <= mul_a;
            mul_b_reg <= mul_b;
            en_reg <= mul_en_in;
            
            // Stage 2: Final accumulation and output
            product_reg <= (mul_b_reg[0] ? {8'b0, mul_a_reg} : 16'b0) +
                          (mul_b_reg[1] ? {7'b0, mul_a_reg, 1'b0} : 16'b0) +
                          (mul_b_reg[2] ? {6'b0, mul_a_reg, 2'b0} : 16'b0) +
                          (mul_b_reg[3] ? {5'b0, mul_a_reg, 3'b0} : 16'b0) +
                          (mul_b_reg[4] ? {4'b0, mul_a_reg, 4'b0} : 16'b0) +
                          (mul_b_reg[5] ? {3'b0, mul_a_reg, 5'b0} : 16'b0) +
                          (mul_b_reg[6] ? {2'b0, mul_a_reg, 6'b0} : 16'b0) +
                          (mul_b_reg[7] ? {1'b0, mul_a_reg, 7'b0} : 16'b0);
            
            // Output assignment
            mul_en_out <= en_reg;
            mul_out <= en_reg ? product_reg : 16'b0;
        end
    end

endmodule