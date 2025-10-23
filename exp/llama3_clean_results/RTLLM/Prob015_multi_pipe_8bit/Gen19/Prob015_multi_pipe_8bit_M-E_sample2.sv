module multi_pipe_8bit(
    input clk,
    input rst_n,
    input mul_en_in,
    input [7:0] mul_a,
    input [7:0] mul_b,
    output reg mul_en_out,
    output reg [15:0] mul_out
);

// Booth's encoding stage
reg [7:0] booth_encoded;
reg [7:0] mul_a_reg;
reg [7:0] mul_b_reg;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        booth_encoded <= 8'b0;
        mul_a_reg <= 8'b0;
        mul_b_reg <= 8'b0;
    end else if (mul_en_in) begin
        mul_a_reg <= mul_a;
        mul_b_reg <= mul_b;
        booth_encoded <= {mul_b_reg[7], mul_b_reg[6], mul_b_reg[5], mul_b_reg[4], mul_b_reg[3], mul_b_reg[2], mul_b_reg[1], mul_b_reg[0]};
    end
end

// Partial product generation stage
reg [15:0] partial_products [7:0];
reg [15:0] partial_sums [6:0];

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        for (int i = 0; i < 8; i++) begin
            partial_products[i] <= 16'b0;
        end
        for (int i = 0; i < 7; i++) begin
            partial_sums[i] <= 16'b0;
        end
    end else if (mul_en_in) begin
        for (int i = 0; i < 8; i++) begin
            if (booth_encoded[i] == 1'b1) begin
                partial_products[i] <= {8'b0, mul_a_reg} << i;
            end else begin
                partial_products[i] <= 16'b0;
            end
        end
        partial_sums[0] <= partial_products[0] + partial_products[1];
        partial_sums[1] <= partial_products[2] + partial_products[3];
        partial_sums[2] <= partial_products[4] + partial_products[5];
        partial_sums[3] <= partial_products[6] + partial_products[7];
        partial_sums[4] <= partial_sums[0] + partial_sums[1];
        partial_sums[5] <= partial_sums[2] + partial_sums[3];
        partial_sums[6] <= partial_sums[4] + partial_sums[5];
    end
end

// Wallace tree reduction stage
reg [15:0] final_product;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        final_product <= 16'b0;
    end else if (mul_en_in) begin
        final_product <= partial_sums[6];
    end
end

// Output stage
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        mul_en_out <= 1'b0;
        mul_out <= 16'b0;
    end else if (mul_en_in) begin
        mul_en_out <= 1'b1;
        mul_out <= final_product;
    end else begin
        mul_en_out <= 1'b0;
        mul_out <= 16'b0;
    end
end

endmodule