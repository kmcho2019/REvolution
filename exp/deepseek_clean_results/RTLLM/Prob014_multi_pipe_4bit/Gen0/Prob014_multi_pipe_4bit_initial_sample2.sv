module multi_pipe_4bit (
    input clk,
    input rst_n,
    input [3:0] mul_a,
    input [3:0] mul_b,
    output reg [7:0] mul_out
);

parameter size = 4;

// Extended inputs
wire [7:0] a_ext = {4'b0, mul_a};
wire [7:0] b_ext = {4'b0, mul_b};

// Partial products
wire [7:0] pp0 = b_ext[0] ? a_ext : 8'd0;
wire [7:0] pp1 = b_ext[1] ? (a_ext << 1) : 8'd0;
wire [7:0] pp2 = b_ext[2] ? (a_ext << 2) : 8'd0;
wire [7:0] pp3 = b_ext[3] ? (a_ext << 3) : 8'd0;

// Pipeline registers
reg [7:0] stage1_sum;
reg [7:0] stage2_sum;

// Pipeline stage 1: adds pp0 and pp1
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        stage1_sum <= 8'd0;
    end else begin
        stage1_sum <= pp0 + pp1;
    end
end

// Pipeline stage 2: adds pp2 and pp3
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        stage2_sum <= 8'd0;
    end else begin
        stage2_sum <= pp2 + pp3;
    end
end

// Final output stage: combines results from both pipeline stages
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        mul_out <= 8'd0;
    end else begin
        mul_out <= stage1_sum + stage2_sum;
    end
end

endmodule