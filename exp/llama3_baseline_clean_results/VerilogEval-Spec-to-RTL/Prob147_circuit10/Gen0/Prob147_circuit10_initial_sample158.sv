module TopModule (
    input  clk,
    input  a,
    input  b,
    output q,
    output state
);

reg state_reg;
assign state = state_reg;

always @(posedge clk) begin
    if (~a) state_reg <= ~state_reg;
end

assign q = (b) ? ~state : state;

endmodule