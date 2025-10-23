module multi_pipe_4bit #(
    parameter size = 4
) (
    input clk,
    input rst_n,
    input [size-1:0] mul_a,
    input [size-1:0] mul_b,
    output reg [2*size-1:0] mul_out
);

// Extended multiplicand with zero padding
wire [2*size-1:0] ext_a = {{size{1'b0}}, mul_a};

// Generate partial products
wire [2*size-1:0] pp [0:size-1];
genvar i;
generate
    for (i = 0; i < size; i = i + 1) begin : PARTIAL_PRODUCTS
        assign pp[i] = mul_b[i] ? (ext_a << i) : {(2*size){1'b0}};
    end
endgenerate

// Pipeline registers
reg [2*size-1:0] stage1_reg, stage2_reg;

// Combinational sums
wire [2*size-1:0] sum_stage1 = pp[0] + pp[1];
wire [2*size-1:0] sum_stage2 = stage1_reg + pp[2] + pp[3];

// Sequential pipeline
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        stage1_reg <= {(2*size){1'b0}};
        stage2_reg <= {(2*size){1'b0}};
        mul_out <= {(2*size){1'b0}};
    end else begin
        stage1_reg <= sum_stage1;
        stage2_reg <= sum_stage2;
        mul_out <= stage2_reg;
    end
end

endmodule