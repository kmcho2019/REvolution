module multi_pipe_8bit(
    input clk,
    input rst_n,
    input mul_en_in,
    input [7:0] mul_a,
    input [7:0] mul_b,
    output reg mul_en_out,
    output reg [15:0] mul_out
);

// Input Stage
reg [7:0] mul_a_reg;
reg [7:0] mul_b_reg;
reg mul_en_reg;
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
reg [15:0] partial_product;
always @(posedge clk) begin
    if (mul_en_reg) begin
        partial_product <= (mul_b_reg[0] == 1'b1) ? {8'b0, mul_a_reg} : 16'b0;
    end
end

// Partial Sum Calculation Stage
reg [15:0] partial_sum;
reg [15:0] shift_reg [7:0];
integer i;
always @(posedge clk) begin
    if (mul_en_reg) begin
        partial_sum <= partial_product;
        for (i = 1; i < 8; i++) begin
            shift_reg[i] <= (mul_b_reg[i] == 1'b1) ? ({8'b0, mul_a_reg} << i) : 16'b0;
            partial_sum <= partial_sum + shift_reg[i];
        end
    end
end

// Final Product Calculation Stage
reg [15:0] final_product;
reg [2:0] counter;
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        final_product <= 16'b0;
        counter <= 3'b0;
    end else if (mul_en_reg && counter == 3'b111) begin
        final_product <= partial_sum;
        counter <= 3'b0;
    end else if (mul_en_reg) begin
        counter <= counter + 1'b1;
    end
end

// Output Stage
assign mul_en_out = (counter == 3'b111) ? 1'b1 : 1'b0;
assign mul_out = (mul_en_out) ? final_product : 16'b0;

endmodule