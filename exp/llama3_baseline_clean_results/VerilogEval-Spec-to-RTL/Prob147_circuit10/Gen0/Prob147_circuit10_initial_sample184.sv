module TopModule(
    input  clk,
    input  a,
    input  b,
    output q,
    output state
);

reg state_reg;
assign state = state_reg;

always @ (posedge clk) begin
    if (b) begin
        state_reg <= a;
    end else begin
        state_reg <= state_reg;
    end
end

assign q = (b && !state) || (a && !b);

endmodule