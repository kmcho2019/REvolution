module multi_pipe_4bit #(parameter size = 4) (
    input clk,
    input rst_n,
    input [size-1:0] mul_a,
    input [size-1:0] mul_b,
    output reg [2*size-1:0] mul_out
);

// Extended multiplicand with zero padding
wire [2*size-1:0] ext_a = { {size{1'b0}}, mul_a };

// Partial products
wire [2*size-1:0] pp0 = mul_b[0] ? ext_a : 0;
wire [2*size-1:0] pp1 = mul_b[1] ? (ext_a << 1) : 0;
wire [2*size-1:0] pp2 = mul_b[2] ? (ext_a << 2) : 0;
wire [2*size-1:0] pp3 = mul_b[3] ? (ext_a << 3) : 0;

// Pipeline registers
reg [2*size-1:0] stage1_reg;

// Sequential pipeline
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        stage1_reg <= 0;
        mul_out <= 0;
    end else begin
        stage1_reg <= pp0 + pp1;
        mul_out <= stage1_reg + pp2 + pp3;
    end
end

endmodule