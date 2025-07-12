module multi_pipe_4bit #(
    parameter size = 4
) (
    input clk,
    input rst_n,
    input [size-1:0] mul_a,
    input [size-1:0] mul_b,
    output reg [2*size-1:0] mul_out
);

// Pipeline stage 1: Partial products
reg [2*size-1:0] pp0, pp1, pp2, pp3;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        pp0 <= 0;
        pp1 <= 0;
        pp2 <= 0;
        pp3 <= 0;
    end else begin
        pp0 <= mul_b[0] ? mul_a : 0;
        pp1 <= mul_b[1] ? (mul_a << 1) : 0;
        pp2 <= mul_b[2] ? (mul_a << 2) : 0;
        pp3 <= mul_b[3] ? (mul_a << 3) : 0;
    end
end

// Pipeline stage 2: Accumulation
reg [2*size-1:0] sum;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        sum <= 0;
        mul_out <= 0;
    end else begin
        sum <= pp0 + pp1 + pp2 + pp3;
        mul_out <= sum;
    end
end

endmodule