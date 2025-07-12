module multi_pipe_4bit #(
    parameter size = 4
) (
    input clk,
    input rst_n,
    input [size-1:0] mul_a,
    input [size-1:0] mul_b,
    output reg [2*size-1:0] mul_out
);

// Zero-extended inputs
wire [2*size-1:0] ext_a = {{size{1'b0}}, mul_a};

// Pipeline registers
reg [2*size-1:0] pp0, pp1;       // Stage 1 registers
reg [2*size-1:0] pp2, pp3, sum1; // Stage 2 registers

// Pipeline stage 1: Register first two partial products
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        pp0 <= 0;
        pp1 <= 0;
    end else begin
        pp0 <= mul_b[0] ? ext_a : 0;
        pp1 <= mul_b[1] ? (ext_a << 1) : 0;
    end
end

// Pipeline stage 2: Register next two partial products and intermediate sum
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        pp2 <= 0;
        pp3 <= 0;
        sum1 <= 0;
    end else begin
        pp2 <= mul_b[2] ? (ext_a << 2) : 0;
        pp3 <= mul_b[3] ? (ext_a << 3) : 0;
        sum1 <= pp0 + pp1;
    end
end

// Final output
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        mul_out <= 0;
    end else begin
        mul_out <= sum1 + pp2 + pp3;
    end
end

endmodule