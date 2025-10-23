module TopModule (
    input clk,
    input ar,
    input d,
    output q
);

reg q_reg;
wire next_q = ar ? 1'b0 : d;

always @(posedge clk or posedge ar)
    q_reg <= next_q;

assign q = q_reg;

endmodule