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
wire [2*size-1:0] a_ext = {{size{1'b0}}, mul_a};
wire [2*size-1:0] b_ext = {{size{1'b0}}, mul_b};

// Partial products generation
wire [2*size-1:0] partial_products [0:size-1];
generate
    genvar i;
    for (i=0; i<size; i=i+1) begin : PARTIAL_PRODS
        assign partial_products[i] = b_ext[i] ? (a_ext << i) : {2*size{1'b0}};
    end
endgenerate

// Pipeline Stage 1: Combinational sums
wire [2*size-1:0] stage1_sum0 = partial_products[0] + partial_products[1];
wire [2*size-1:0] stage1_sum1 = partial_products[2] + partial_products[3];

// Pipeline Stage 2: Final sum (registered)
wire [2*size-1:0] final_sum = stage1_sum0 + stage1_sum1;

// Output register
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        mul_out <= 0;
    end else begin
        mul_out <= final_sum;
    end
end

endmodule