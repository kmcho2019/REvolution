module multi_pipe_4bit #(
    parameter size = 4
) (
    input clk,
    input rst_n,
    input [size-1:0] mul_a,
    input [size-1:0] mul_b,
    output reg [2*size-1:0] mul_out
);

// Constants
localparam [2*size-1:0] ZERO = {2*size{1'b0}};

// Extended multiplicand
wire [2*size-1:0] ext_a = {{size{1'b0}}, mul_a};

// Partial products (bitwise AND with shifted multiplicand)
wire [2*size-1:0] pp0 = mul_b[0] ? ext_a       : ZERO;
wire [2*size-1:0] pp1 = mul_b[1] ? ext_a << 1  : ZERO;
wire [2*size-1:0] pp2 = mul_b[2] ? ext_a << 2  : ZERO;
wire [2*size-1:0] pp3 = mul_b[3] ? ext_a << 3  : ZERO;

// Pipeline registers (now properly clocked)
reg [2*size-1:0] stage1_reg;
reg [2*size-1:0] stage2_reg;

// Stage 1 pipeline register (pp0 + pp1)
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        stage1_reg <= ZERO;
    end else begin
        stage1_reg <= pp0 + pp1;
    end
end

// Stage 2 pipeline register (pp2 + pp3)
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        stage2_reg <= ZERO;
    end else begin
        stage2_reg <= pp2 + pp3;
    end
end

// Final output register
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        mul_out <= ZERO;
    end else begin
        mul_out <= stage1_reg + stage2_reg;
    end
end

endmodule