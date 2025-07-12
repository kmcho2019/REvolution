module multi_pipe_4bit #(
    parameter size = 4
)(
    input clk,
    input rst_n,
    input [size-1:0] mul_a,
    input [size-1:0] mul_b,
    output [2*size-1:0] mul_out
);

reg [2*size-1:0] reg1;
reg [2*size-1:0] reg2;

wire [2*size-1:0] partial_product;

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        reg1 <= 0;
        reg2 <= 0;
        mul_out <= 0;
    end else begin
        reg1 <= partial_product;
        reg2 <= reg1;
        mul_out <= reg2;
    end
end

genvar i;
generate
    for (i = 0; i < size; i = i + 1) begin
        wire [2*size-1:0] partial_product_i;
        assign partial_product_i = (mul_b[i] == 1'b1)? {size-1{i}}mul_a : 'd0;
        assign partial_product = (i == 0)? partial_product_i : partial_product_i + partial_product;
    end
endgenerate

endmodule