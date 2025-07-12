module TopModule(
    input  clk,
    input  a,
    input  b,
    output q,
    output state
);

reg state_reg;
assign state = state_reg;

always @(posedge clk) begin
    if (a && b) begin
        state_reg <= ~state_reg;
    end else begin
        state_reg <= state_reg;
    end
end

assign q = (state_reg && !a && !b) || (!a && b) || (a && !b);

endmodule