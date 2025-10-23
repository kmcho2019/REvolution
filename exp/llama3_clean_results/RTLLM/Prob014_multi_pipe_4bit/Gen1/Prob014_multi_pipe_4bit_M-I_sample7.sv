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

integer i;

// Generate partial products
genvar k;
generate
    for (k = 0; k < size; k = k + 1) begin
        assign partial_product[k] = (mul_b[k] == 1'b1)? (mul_a << k) : 8'd0;
    end
endgenerate

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