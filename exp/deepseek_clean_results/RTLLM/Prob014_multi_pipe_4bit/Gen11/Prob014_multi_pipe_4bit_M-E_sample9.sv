module multi_pipe_4bit #(
    parameter size = 4
) (
    input clk,
    input rst_n,
    input [size-1:0] mul_a,
    input [size-1:0] mul_b,
    output reg [2*size-1:0] mul_out
);

// Zero-extended multiplicand
wire [2*size-1:0] ext_a = {{size{1'b0}}, mul_a};

// Pipeline registers
reg [2*size-1:0] stage0, stage1, stage2;

// Stage 0: Process LSB (bit 0)
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        stage0 <= 0;
    end else begin
        stage0 <= mul_b[0] ? ext_a : 0;
    end
end

// Stage 1: Process bit 1 and accumulate
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        stage1 <= 0;
    end else begin
        stage1 <= stage0 + (mul_b[1] ? (ext_a << 1) : 0);
    end
end

// Stage 2: Process bit 2 and accumulate
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        stage2 <= 0;
    end else begin
        stage2 <= stage1 + (mul_b[2] ? (ext_a << 2) : 0);
    end
end

// Stage 3: Process MSB (bit 3) and produce final result
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        mul_out <= 0;
    end else begin
        mul_out <= stage2 + (mul_b[3] ? (ext_a << 3) : 0);
    end
end

endmodule