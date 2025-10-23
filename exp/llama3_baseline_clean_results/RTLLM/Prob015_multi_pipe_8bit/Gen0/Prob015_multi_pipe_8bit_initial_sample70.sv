module multi_pipe_8bit (
    input clk,
    input rst_n,
    input mul_en_in,
    input [7:0] mul_a,
    input [7:0] mul_b,
    output mul_en_out,
    output [15:0] mul_out
);

// Input Control
reg mul_en_out_reg;
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        mul_en_out_reg <= 1'b0;
    end else if (mul_en_in) begin
        mul_en_out_reg <= mul_en_in;
    end else begin
        mul_en_out_reg <= mul_en_out_reg;
    end
end

assign mul_en_out = mul_en_out_reg;

// Input Registers
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

// Partial Product Generation
wire [15:0] temp [7:0];
genvar i;
generate
    for (i = 0; i < 8; i++) begin
        assign temp[i] = (mul_a_reg << i) & {16{(mul_b_reg[i])};
    end
endgenerate

// Partial Sum Calculation
reg [15:0] sum [7:0];
integer j;
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        for (j = 0; j < 8; j++) begin
            sum[j] <= 16'b0;
        end
    end else begin
        sum[0] <= temp[0];
        for (j = 1; j < 8; j++) begin
            sum[j] <= sum[j-1] + temp[j];
        end
    end
end

// Final Product Calculation
reg [15:0] mul_out_reg;
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        mul_out_reg <= 16'b0;
    end else begin
        mul_out_reg <= sum[7];
    end
end

// Output Assignment
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        mul_out <= 16'b0;
    end else if (mul_en_out_reg) begin
        mul_out <= mul_out_reg;
    end else begin
        mul_out <= 16'b0;
    end
end

endmodule