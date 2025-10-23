module TopModule(
    input clk,
    input a,
    input b,
    output q,
    output state
);

reg state_reg;
assign state = state_reg;

always @(posedge clk) begin
    if (a == 1) begin
        state_reg <= ~state_reg;
    end else if (b == 1) begin
        state_reg <= 0;
    end else begin
        state_reg <= state_reg;
    end
end

assign q = (b == 1) ? 1 : state_reg;

endmodule