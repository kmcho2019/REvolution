module multi_pipe_4bit #(
    parameter size = 4
) (
    input clk,
    input rst_n,
    input [size-1:0] mul_a,
    input [size-1:0] mul_b,
    output reg [2*size-1:0] mul_out
);

// Extend multiplicand by size bits (as per requirements)
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

// Pipeline Stage 1 Logic
wire [2*size-1:0] stage1_sum0 = partial_products[0] + partial_products[1];
wire [2*size-1:0] stage1_sum1 = partial_products[2] + partial_products[3];

// Pipeline Stage 2 Register
reg [2*size-1:0] stage2_reg;

// Pipeline Stage 2 Logic
wire [2*size-1:0] final_sum = stage1_reg0 + stage1_reg1;

// Pipeline Control
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        // Reset all pipeline registers
        stage1_reg0 <= 0;
        stage1_reg1 <= 0;
        stage2_reg <= 0;
        mul_out <= 0;
    end else begin
        // First pipeline stage
        stage1_reg0 <= stage1_sum0;
        stage1_reg1 <= stage1_sum1;
        
        // Second pipeline stage
        stage2_reg <= final_sum;
        
        // Final output
        mul_out <= stage2_reg;
    end
end

endmodule