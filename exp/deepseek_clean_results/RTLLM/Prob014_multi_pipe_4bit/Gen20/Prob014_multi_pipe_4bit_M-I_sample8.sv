module multi_pipe_4bit #(parameter size = 4) (
    input clk,
    input rst_n,
    input [size-1:0] mul_a,
    input [size-1:0] mul_b,
    output reg [2*size-1:0] mul_out
);

// Pipeline stage 1 registers
reg [2*size-1:0] pp0_reg, pp1_reg, pp2_reg, pp3_reg;
reg [size-1:0] mul_a_reg, mul_b_reg;

// Pipeline stage 2 register
reg [2*size-1:0] sum_reg;

// Stage 1: Partial product generation
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        mul_a_reg <= 0;
        mul_b_reg <= 0;
        pp0_reg <= 0;
        pp1_reg <= 0;
        pp2_reg <= 0;
        pp3_reg <= 0;
    end else begin
        // Register inputs
        mul_a_reg <= mul_a;
        mul_b_reg <= mul_b;
        
        // Generate all partial products in parallel
        pp0_reg <= mul_b[0] ? { {size{1'b0}}, mul_a } : 0;
        pp1_reg <= mul_b[1] ? { {size-1{1'b0}}, mul_a, 1'b0 } : 0;
        pp2_reg <= mul_b[2] ? { {size-2{1'b0}}, mul_a, 2'b0 } : 0;
        pp3_reg <= mul_b[3] ? { {size-3{1'b0}}, mul_a, 3'b0 } : 0;
    end
end

// Stage 2: Accumulation
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        sum_reg <= 0;
        mul_out <= 0;
    end else begin
        // Sum all partial products
        sum_reg <= pp0_reg + pp1_reg + pp2_reg + pp3_reg;
        
        // Register final output
        mul_out <= sum_reg;
    end
end

endmodule