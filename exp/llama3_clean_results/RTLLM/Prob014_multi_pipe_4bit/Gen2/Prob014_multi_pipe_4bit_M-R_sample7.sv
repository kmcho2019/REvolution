module multi_pipe_4bit(
    input               clk,
    input               rst_n,
    input   [3:0]       mul_a,
    input   [3:0]       mul_b,
    output  [7:0]       mul_out
);

parameter size = 4;

reg   [7:0]       reg1;
reg   [7:0]       reg2;
reg   [7:0]       mul_out_reg;

wire  [7:0]       partial_product [3:0];

// Generate partial products
assign partial_product[0] = (mul_b[0] == 1'b1)? {4'd0, mul_a} : 8'd0;
assign partial_product[1] = (mul_b[1] == 1'b1)? {2'd0, mul_a, 2'd0} : 8'd0;
assign partial_product[2] = (mul_b[2] == 1'b1)? {1'd0, mul_a, 3'd0} : 8'd0;
assign partial_product[3] = (mul_b[3] == 1'b1)? {mul_a, 4'd0} : 8'd0;

// Store intermediate sum values
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        reg1 <= 8'd0;
        reg2 <= 8'd0;
        mul_out_reg <= 8'd0;
    end else begin
        reg1 <= partial_product[0] + partial_product[1];
        reg2 <= reg1 + partial_product[2] + partial_product[3];
        mul_out_reg <= reg2;
    end
end

// Calculate final product
assign mul_out = mul_out_reg;

endmodule