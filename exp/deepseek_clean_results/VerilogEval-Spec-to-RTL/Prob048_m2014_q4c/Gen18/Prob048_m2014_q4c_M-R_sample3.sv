module TopModule (
    input  clk,
    input  d,
    input  r,
    output q
);

reg q_reg;
wire next_q = r ? 1'b0 : d;

assign q = q_reg;

always @(posedge clk) begin
    q_reg <= next_q;
end

endmodule