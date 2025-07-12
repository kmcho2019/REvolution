module multi_pipe_8bit (
    input clk,
    input rst_n,
    input mul_en_in,
    input [7:0] mul_a,
    input [7:0] mul_b,
    output mul_en_out,
    output [15:0] mul_out
);

// Input control
reg mul_en_out_reg;
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        mul_en_out_reg <= 1'b0;
    end else if (mul_en_in) begin
        mul_en_out_reg <= 1'b1;
    end else begin
        mul_en_out_reg <= 1'b0;
    end
end

assign mul_en_out = mul_en_out_reg;

// Input registers
reg [7:0] mul_a_reg;
reg [7:0] mul_b_reg;
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        mul_a_reg <= 8'b0;
        mul_b_reg <= 8'b0;
    end else if (mul_en_in) begin
        mul_a_reg <= mul_a;
        mul_b_reg <= mul_b;
    end else begin
        mul_a_reg <= mul_a_reg;
        mul_b_reg <= mul_b_reg;
    end
end

// Partial product generation
wire [15:0] temp;
assign temp = (mul_a_reg * mul_b_reg);

// Partial sum calculation and final product calculation
reg [15:0] sum;
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        sum <= 16'b0;
    end else if (mul_en_in) begin
        sum <= temp;
    end else begin
        sum <= sum;
    end
end

// Output assignment
reg [15:0] mul_out_reg;
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        mul_out_reg <= 16'b0;
    end else if (mul_en_out) begin
        mul_out_reg <= sum;
    end else begin
        mul_out_reg <= 16'b0;
    end
end

assign mul_out = mul_out_reg;

endmodule