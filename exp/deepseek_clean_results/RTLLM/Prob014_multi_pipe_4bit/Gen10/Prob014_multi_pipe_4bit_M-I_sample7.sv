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

// Pipeline stage 1 registers
reg [7:0] stage1_sum01, stage1_sum23;

// Generate all partial products
wire [7:0] pp0 = mul_b[0] ? ext_a : 8'b0;
wire [7:0] pp1 = mul_b[1] ? (ext_a << 1) : 8'b0;
wire [7:0] pp2 = mul_b[2] ? (ext_a << 2) : 8'b0;
wire [7:0] pp3 = mul_b[3] ? (ext_a << 3) : 8'b0;

// Pipeline stage 1 logic
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        stage1_sum01 <= 8'b0;
        stage1_sum23 <= 8'b0;
    end else begin
        // First pipeline stage adds PP0+PP1 and PP2+PP3
        stage1_sum01 <= pp0 + pp1;
        stage1_sum23 <= pp2 + pp3;
    end
end

// Pipeline stage 2 (final output)
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        mul_out <= 8'b0;
    end else begin
        // Second pipeline stage adds the two intermediate sums
        mul_out <= stage1_sum01 + stage1_sum23;
    end
end

endmodule