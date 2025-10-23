module multi_pipe_4bit #(
    parameter size = 4
)(
    input clk,
    input rst_n,
    input [size-1:0] mul_a,
    input [size-1:0] mul_b,
    output reg [2*size-1:0] mul_out
);

reg [2*size-1:0] reg1;
reg [2*size-1:0] reg2;

// Initialize registers
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        reg1 <= 0;
        reg2 <= 0;
    end else begin
        reg1 <= partial_sum;
        reg2 <= reg1;
    end
end

// Calculate final product
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        mul_out <= 0;
    end else begin
        mul_out <= reg2;
    end
end

// Calculate partial sum using a generate block
wire [2*size-1:0] partial_sum;
assign partial_sum = partial_sum_gen;

wire [2*size-1:0] partial_sum_gen;
genvar i;
assign partial_sum_gen = {2*size{1'b0}};
generate
    for (i = 0; i < size; i = i + 1) begin
        wire [2*size-1:0] partial_product;
        assign partial_product = (mul_b[i] == 1'b1) ? (mul_a << i) : {2*size{1'b0}};
        assign partial_sum_gen = partial_sum_gen + partial_product;
    end
endgenerate

endmodule