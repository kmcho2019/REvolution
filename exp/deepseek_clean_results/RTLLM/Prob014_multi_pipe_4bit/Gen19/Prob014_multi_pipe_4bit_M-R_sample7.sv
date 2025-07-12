module multi_pipe_4bit #(parameter size = 4) (
    input clk,
    input rst_n,
    input [size-1:0] mul_a,
    input [size-1:0] mul_b,
    output reg [2*size-1:0] mul_out
);

// Extended multiplicand
wire [2*size-1:0] ext_a = {{size{1'b0}}, mul_a};

// Partial products
wire [2*size-1:0] pp0 = mul_b[0] ? ext_a : {2*size{1'b0}};
wire [2*size-1:0] pp1 = mul_b[1] ? (ext_a << 1) : {2*size{1'b0}};
wire [2*size-1:0] pp2 = mul_b[2] ? (ext_a << 2) : {2*size{1'b0}};
wire [2*size-1:0] pp3 = mul_b[3] ? (ext_a << 3) : {2*size{1'b0}};

// Pipeline registers
reg [2*size-1:0] stage1_reg;  // First stage sum (pp0 + pp1)
reg [2*size-1:0] stage2_reg;  // Second stage sum (stage1 + pp2 + pp3)

// First stage sum (combinational)
wire [2*size-1:0] sum_stage1 = pp0 + pp1;

// Second stage sum (combinational)
wire [2*size-1:0] sum_stage2 = stage1_reg + pp2 + pp3;

// Pipeline update logic
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        stage1_reg <= {2*size{1'b0}};
        stage2_reg <= {2*size{1'b0}};
        mul_out <= {2*size{1'b0}};
    end else begin
        stage1_reg <= sum_stage1;
        stage2_reg <= sum_stage2;
        mul_out <= stage2_reg;
    end
end

endmodule