module multi_pipe_4bit(
    input clk,
    input rst_n,
    input [3:0] mul_a,
    input [3:0] mul_b,
    output [7:0] mul_out
);

parameter size = 4;

reg [7:0] stage1_reg;
reg [7:0] stage2_reg;

wire [7:0] partial_product [3:0];

integer i;

// generate partial products
generate
    for (i = 0; i < size; i = i + 1) begin
        assign partial_product[i] = (mul_b[i])? (mul_a << i) : 8'd0;
    end
endgenerate

// first stage
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        stage1_reg <= 8'd0;
    end else begin
        stage1_reg <= partial_product[0] + partial_product[1] + partial_product[2] + partial_product[3];
    end
end

// second stage
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        stage2_reg <= 8'd0;
    end else begin
        stage2_reg <= stage1_reg;
    end
end

// output product
assign mul_out = stage2_reg;

endmodule