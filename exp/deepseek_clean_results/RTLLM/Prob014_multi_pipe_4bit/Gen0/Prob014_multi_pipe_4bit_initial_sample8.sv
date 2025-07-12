module multi_pipe_4bit (
    input clk,
    input rst_n,
    input [3:0] mul_a,
    input [3:0] mul_b,
    output reg [7:0] mul_out
);

parameter size = 4;

// Extended inputs
wire [7:0] ext_a = {4'b0, mul_a};
wire [7:0] ext_b = {4'b0, mul_b};

// Partial products
wire [7:0] pp [0:3];
genvar i;
generate
    for (i = 0; i < size; i = i + 1) begin : PARTIAL_PRODUCTS
        assign pp[i] = mul_b[i] ? (ext_a << i) : 8'd0;
    end
endgenerate

// Pipeline registers
reg [7:0] stage1_reg;
reg [7:0] stage2_reg;

// First pipeline stage: sum of pp[0] and pp[1]
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        stage1_reg <= 8'd0;
    end else begin
        stage1_reg <= pp[0] + pp[1];
    end
end

// Second pipeline stage: sum of pp[2] and pp[3]
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        stage2_reg <= 8'd0;
    end else begin
        stage2_reg <= pp[2] + pp[3];
    end
end

// Final output stage
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        mul_out <= 8'd0;
    end else begin
        mul_out <= stage1_reg + stage2_reg;
    end
end

endmodule