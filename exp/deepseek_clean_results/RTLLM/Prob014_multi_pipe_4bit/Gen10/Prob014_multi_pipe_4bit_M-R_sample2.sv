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
wire [2*size-1:0] ext_b = {{size{1'b0}}, mul_b};

// Partial products generation
wire [2*size-1:0] partial_products [0:size-1];
generate
    genvar i;
    for (i=0; i<size; i=i+1) begin : PP_GEN
        assign partial_products[i] = ext_b[i] ? (ext_a << i) : {2*size{1'b0}};
    end
endgenerate

// Pipeline stage 1: First addition (combinational)
wire [2*size-1:0] stage1_sum = partial_products[0] + partial_products[1];

// Pipeline stage 2: Second addition (combinational)
wire [2*size-1:0] stage2_sum = partial_products[2] + partial_products[3];

// Final output register (sequential)
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        mul_out <= 0;
    end else begin
        mul_out <= stage1_sum + stage2_sum;
    end
end

endmodule