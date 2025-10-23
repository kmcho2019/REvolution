module multi_pipe_8bit(
    input clk,
    input rst_n,
    input mul_en_in,
    input [7:0] mul_a,
    input [7:0] mul_b,
    output reg mul_en_out,
    output reg [15:0] mul_out
);

reg [7:0] mul_a_reg;
reg [7:0] mul_b_reg;
reg [15:0] partial_product [7:0];
reg [15:0] partial_sum [7:0];
reg [15:0] final_product;
reg [2:0] counter;
reg mul_en_reg;

// Input Stage
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        mul_a_reg <= 8'b0;
        mul_b_reg <= 8'b0;
        mul_en_reg <= 1'b0;
    end else if (mul_en_in) begin
        mul_a_reg <= mul_a;
        mul_b_reg <= mul_b;
        mul_en_reg <= 1'b1;
    end
end

// Partial Product Generation Stage
always @(posedge clk) begin
    if (mul_en_reg) begin
        for (int i = 0; i < 8; i++) begin
            if (mul_b_reg[i] == 1'b1) begin
                partial_product[i] <= {8'b0, mul_a_reg} << i;
            end else begin
                partial_product[i] <= 16'b0;
            end
        end
    end
end

// Partial Sum Calculation Stage
always @(posedge clk) begin
    if (mul_en_reg) begin
        partial_sum[0] <= partial_product[0];
        for (int i = 1; i < 8; i++) begin
            partial_sum[i] <= partial_sum[i-1] + partial_product[i];
        end
    end
end

// Final Product Calculation Stage
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        final_product <= 16'b0;
        counter <= 3'b0;
    end else if (mul_en_reg && counter == 3'b111) begin
        final_product <= partial_sum[7];
        counter <= 3'b0;
    end else if (mul_en_reg && counter < 3'b111) begin
        counter <= counter + 1'b1;
    end else if (!mul_en_reg) begin
        counter <= 3'b0;
    end
end

// Output Stage
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        mul_en_out <= 1'b0;
        mul_out <= 16'b0;
    end else if (counter == 3'b111) begin
        mul_en_out <= 1'b1;
        mul_out <= final_product;
    end else begin
        mul_en_out <= 1'b0;
    end
end

endmodule