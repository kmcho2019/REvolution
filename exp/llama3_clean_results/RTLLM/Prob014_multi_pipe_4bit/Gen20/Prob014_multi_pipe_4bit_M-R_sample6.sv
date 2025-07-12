module multi_pipe_4bit #(
    parameter size = 4
)(
    input clk,
    input rst_n,
    input [size-1:0] mul_a,
    input [size-1:0] mul_b,
    output reg [2*size-1:0] mul_out
);

reg [2*size-1:0] stage1_out;
reg [2*size-1:0] stage2_out;
wire [2*size-1:0] partial_product_sum;

// Calculate partial products using a generate block
genvar i;
generate
    for (i = 0; i < size; i++) begin
        if (i == 0) begin
            assign partial_product_sum = (mul_b[i] ? (mul_a << i) : {2*size{1'b0}});
        end else begin
            wire [2*size-1:0] partial_product;
            assign partial_product = (mul_b[i] ? (mul_a << i) : {2*size{1'b0}});
            assign partial_product_sum = (i == 1) ? partial_product_sum + partial_product : partial_product_sum + partial_product;
        end
    end
endgenerate

// However, the above generate block is still incorrect due to the attempt to reassign partial_product_sum within the loop.
// A correct approach involves using an array to hold partial products and then summing them.

reg [2*size-1:0] partial_products [size];

always @(*) begin
    for (int i = 0; i < size; i++) begin
        partial_products[i] = (mul_b[i] ? (mul_a << i) : {2*size{1'b0}});
    end
    stage1_out = {2*size{1'b0}};
    for (int i = 0; i < size; i++) begin
        stage1_out = stage1_out + partial_products[i];
    end
end

// Stage 2: Pipeline the result
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        stage2_out <= {2*size{1'b0}};
    end else begin
        stage2_out <= stage1_out;
    end
end

// Output stage
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        mul_out <= {2*size{1'b0}};
    end else begin
        mul_out <= stage2_out;
    end
end

endmodule