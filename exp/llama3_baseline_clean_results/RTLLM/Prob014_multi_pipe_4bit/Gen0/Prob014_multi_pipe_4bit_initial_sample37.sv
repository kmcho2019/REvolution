module multi_pipe_4bit(
    input clk,
    input rst_n,
    input [3:0] mul_a,
    input [3:0] mul_b,
    output reg [7:0] mul_out
);

parameter size = 4;

// Level 1 registers to store the multiplicand extended with zeros
reg [7:0] level1_reg;

// Level 2 registers to store the intermediate sum values
reg [7:0] level2_reg;

// Initialize level1_reg and level2_reg with zeros on reset
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        level1_reg <= 8'd0;
        level2_reg <= 8'd0;
    end else begin
        level1_reg <= {4'd0, mul_a};
        level2_reg <= level1_reg;
    end
end

// Perform multiplication operation and calculate the final product
reg [7:0] final_product;
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        final_product <= 8'd0;
    end else begin
        final_product <= 8'd0;
        for (int i = 0; i < size; i++) begin
            if (mul_b[i]) begin
                final_product <= final_product + (level1_reg << i);
            end
        end
    end
end

// Update the product output (mul_out)
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        mul_out <= 8'd0;
    end else begin
        mul_out <= final_product;
    end
end

endmodule