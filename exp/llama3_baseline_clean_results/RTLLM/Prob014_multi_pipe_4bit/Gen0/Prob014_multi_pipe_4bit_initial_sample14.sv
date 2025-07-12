module multi_pipe_4bit(
    input clk,
    input rst_n,
    input [3:0] mul_a,
    input [3:0] mul_b,
    output reg [7:0] mul_out
);

// Internal signals
reg [7:0] partial_product [3:0];
reg [7:0] sum_reg1;
reg [7:0] sum_reg2;

// Generate block for multiplication
genvar i;
generate
    for (i = 0; i < 4; i = i + 1) begin: GEN_BLOCK
        always @(*) begin
            if (mul_b[i] == 1'b1) begin
                partial_product[i] = {4'd0, mul_a} << i;
            end else begin
                partial_product[i] = 8'd0;
            end
        end
    end
endgenerate

// Add partial products and store in registers
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        sum_reg1 <= 8'd0;
        sum_reg2 <= 8'd0;
    end else begin
        sum_reg1 <= partial_product[0] + partial_product[1];
        sum_reg2 <= partial_product[2] + partial_product[3];
    end
end

// Calculate final product
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        mul_out <= 8'd0;
    end else begin
        mul_out <= sum_reg1 + sum_reg2;
    end
end

endmodule