module multi_pipe_4bit (
    input clk,
    input rst_n,
    input [3:0] mul_a,
    input [3:0] mul_b,
    output reg [7:0] mul_out
);

parameter size = 4;

// Zero-extended inputs
wire [7:0] a_ext = {4'b0, mul_a};
wire [7:0] b_ext = {4'b0, mul_b};

// Pipeline stage 1 registers (partial products)
reg [7:0] pp0, pp1, pp2, pp3;

// Pipeline stage 2 register (accumulator)
reg [7:0] sum;

// Stage 1: Partial product generation
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        pp0 <= 8'b0;
        pp1 <= 8'b0;
        pp2 <= 8'b0;
        pp3 <= 8'b0;
    end else begin
        pp0 <= mul_b[0] ? a_ext : 8'b0;
        pp1 <= mul_b[1] ? (a_ext << 1) : 8'b0;
        pp2 <= mul_b[2] ? (a_ext << 2) : 8'b0;
        pp3 <= mul_b[3] ? (a_ext << 3) : 8'b0;
    end
end

// Stage 2: Accumulation
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        sum <= 8'b0;
    end else begin
        sum <= pp0 + pp1 + pp2 + pp3;
    end
end

// Output assignment
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        mul_out <= 8'b0;
    end else begin
        mul_out <= sum;
    end
end

endmodule