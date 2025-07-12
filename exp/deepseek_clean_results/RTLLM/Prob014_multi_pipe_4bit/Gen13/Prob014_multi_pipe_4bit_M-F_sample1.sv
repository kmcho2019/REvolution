module multi_pipe_4bit #(
    parameter size = 4
) (
    input clk,
    input rst_n,
    input [size-1:0] mul_a,
    input [size-1:0] mul_b,
    output reg [2*size-1:0] mul_out
);

// Extend multiplicand only (add 'size' zeros at MSB)
wire [2*size-1:0] a_ext = {{size{1'b0}}, mul_a};

// Partial products generation
wire [2*size-1:0] partial_products [0:size-1];
generate
    genvar i;
    for (i=0; i<size; i=i+1) begin : PARTIAL_PRODS
        assign partial_products[i] = mul_b[i] ? (a_ext << i) : {2*size{1'b0}};
    end
endgenerate

// Pipeline Stage 1 Registers
reg [2*size-1:0] stage1_reg0, stage1_reg1;

// Pipeline Stage 2 Register
reg [2*size-1:0] stage2_reg;

// Pipeline Stage 1: Register partial sums
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        stage1_reg0 <= 0;
        stage1_reg1 <= 0;
    end else begin
        stage1_reg0 <= partial_products[0] + partial_products[1];
        stage1_reg1 <= partial_products[2] + partial_products[3];
    end
end

// Pipeline Stage 2: Register final sum
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        stage2_reg <= 0;
    end else begin
        stage2_reg <= stage1_reg0 + stage1_reg1;
    end
end

// Output assignment (direct from final pipeline stage)
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        mul_out <= 0;
    end else begin
        mul_out <= stage2_reg;
    end
end

endmodule