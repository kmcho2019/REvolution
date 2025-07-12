module TopModule(
    input clk,
    input a,
    input b,
    output q,
    output state
);

reg state_reg;

assign q = (a) ? ~b : b;

always @(posedge clk) begin
    state_reg <= q;
end

assign state = state_reg;

endmodule