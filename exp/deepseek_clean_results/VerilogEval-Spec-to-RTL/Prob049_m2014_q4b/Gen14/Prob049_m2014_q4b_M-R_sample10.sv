module TopModule (
    input clk,
    input ar,
    input d,
    output q
);

reg q_reg = 1'b0;
wire next_q = ar ? 1'b0 : d;

always @(posedge clk)
    q_reg <= next_q;

assign q = q_reg;

endmodule