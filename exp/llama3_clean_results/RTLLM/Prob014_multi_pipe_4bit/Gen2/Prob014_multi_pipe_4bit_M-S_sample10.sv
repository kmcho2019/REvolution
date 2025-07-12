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

// Calculate partial products and sum them up in a staged manner
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        reg1 <= 8'd0;
        reg2 <= 8'd0;
        mul_out_reg <= 8'd0;
    end else begin
        reg1 <= (mul_b[0] == 1'b1) ? mul_a : 8'd0;
        reg1 <= reg1 + ((mul_b[1] == 1'b1) ? (mul_a << 1) : 8'd0);
        
        reg2 <= reg1 + ((mul_b[2] == 1'b1) ? (mul_a << 2) : 8'd0);
        reg2 <= reg2 + ((mul_b[3] == 1'b1) ? (mul_a << 3) : 8'd0);
        
        mul_out_reg <= reg2;
    end
end

// Calculate final product
assign mul_out = mul_out_reg;

endmodule