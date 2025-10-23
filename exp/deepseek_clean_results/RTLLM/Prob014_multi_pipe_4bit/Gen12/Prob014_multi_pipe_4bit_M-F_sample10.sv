module multi_pipe_4bit (
    input clk,
    input rst_n,
    input [3:0] mul_a,
    input [3:0] mul_b,
    output reg [7:0] mul_out
);

parameter size = 4;

// Pipeline stage 1 registers
reg [7:0] partial_products [0:3];
reg [3:0] mul_b_reg;

// Pipeline stage 2 registers
reg [7:0] sum_reg1;
reg [7:0] sum_reg2;

// Generate all partial products (Stage 1)
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        for (integer i = 0; i < 4; i = i + 1) begin
            partial_products[i] <= 8'b0;
        end
        mul_b_reg <= 4'b0;
    end else begin
        // Generate all shifted versions of mul_a
        partial_products[0] <= {4'b0, mul_a};
        partial_products[1] <= {3'b0, mul_a, 1'b0};
        partial_products[2] <= {2'b0, mul_a, 2'b0};
        partial_products[3] <= {1'b0, mul_a, 3'b0};
        
        // Register multiplier for next stage
        mul_b_reg <= mul_b;
    end
end

// Accumulate partial products (Stage 2)
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        sum_reg1 <= 8'b0;
        sum_reg2 <= 8'b0;
        mul_out <= 8'b0;
    end else begin
        // First level of addition
        sum_reg1 <= (mul_b_reg[0] ? partial_products[0] : 8'b0) + 
                   (mul_b_reg[1] ? partial_products[1] : 8'b0);
        
        // Second level of addition
        sum_reg2 <= (mul_b_reg[2] ? partial_products[2] : 8'b0) + 
                   (mul_b_reg[3] ? partial_products[3] : 8'b0);
        
        // Final sum (registered output)
        mul_out <= sum_reg1 + sum_reg2;
    end
end

endmodule