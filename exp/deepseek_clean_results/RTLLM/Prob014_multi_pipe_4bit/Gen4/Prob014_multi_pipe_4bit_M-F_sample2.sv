module multi_pipe_4bit (
    input clk,
    input rst_n,
    input [3:0] mul_a,
    input [3:0] mul_b,
    output reg [7:0] mul_out
);

parameter size = 4;

// Extend inputs with size zeros at MSB
wire [7:0] a_ext = {4'b0, mul_a};
wire [7:0] b_ext = {4'b0, mul_b};

// Generate partial products
wire [7:0] pp0 = b_ext[0] ? a_ext : 8'b0;
wire [7:0] pp1 = b_ext[1] ? (a_ext << 1) : 8'b0;
wire [7:0] pp2 = b_ext[2] ? (a_ext << 2) : 8'b0;
wire [7:0] pp3 = b_ext[3] ? (a_ext << 3) : 8'b0;

// Pipeline stage 1: sum pp0 and pp1
reg [7:0] sum_stage1;
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        sum_stage1 <= 8'b0;
    end else begin
        sum_stage1 <= pp0 + pp1;
    end
end

// Pipeline stage 2: add pp2 to previous sum
reg [7:0] sum_stage2;
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        sum_stage2 <= 8'b0;
    end else begin
        sum_stage2 <= sum_stage1 + pp2;
    end
end

// Final output: add pp3 to accumulated sum
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        mul_out <= 8'b0;
    end else begin
        mul_out <= sum_stage2 + pp3;
    end
end

endmodule