module TopModule (
    input  clk,
    input  d,
    input  r,
    output q
);

reg q_reg;

assign q = q_reg;

always @(posedge clk) begin
    q_reg <= r ? 1'b0 : d;
end

endmodule