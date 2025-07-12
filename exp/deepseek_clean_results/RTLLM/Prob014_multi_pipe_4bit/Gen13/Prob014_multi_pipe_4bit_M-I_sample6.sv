module multi_pipe_4bit #(
    parameter size = 4
) (
    input clk,
    input rst_n,
    input [size-1:0] mul_a,
    input [size-1:0] mul_b,
    output reg [2*size-1:0] mul_out
);

// Extend multiplicand by size bits
wire [2*size-1:0] a_ext = {{size{1'b0}}, mul_a};

// Generate partial products
wire [2*size-1:0] partial_products [0:size-1];
generate
    genvar i;
    for (i=0; i<size; i=i+1) begin : PARTIAL_PRODS
        assign partial_products[i] = mul_b[i] ? (a_ext << i) : {2*size{1'b0}};
    end
endgenerate

// Pipeline control signals
wire pipe_enable = 1'b1;  // Could be connected to external enable if needed

// Pipeline Stage 1: Sum of first two and last two partial products
reg [2*size-1:0] stage1_sum0, stage1_sum1;

// Pipeline Stage 2: Final sum of intermediate results
reg [2*size-1:0] stage2_sum;

// Combinational sums for pipeline stages
wire [2*size-1:0] comb_sum0 = partial_products[0] + partial_products[1];
wire [2*size-1:0] comb_sum1 = partial_products[2] + partial_products[3];
wire [2*size-1:0] comb_final = stage1_sum0 + stage1_sum1;

// Pipeline registers with clock gating
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        // Reset all pipeline registers
        stage1_sum0 <= 0;
        stage1_sum1 <= 0;
        stage2_sum <= 0;
        mul_out <= 0;
    end else if (pipe_enable) begin
        // First pipeline stage
        stage1_sum0 <= comb_sum0;
        stage1_sum1 <= comb_sum1;
        
        // Second pipeline stage
        stage2_sum <= comb_final;
        
        // Final output
        mul_out <= stage2_sum;
    end
end

endmodule