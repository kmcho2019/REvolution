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
    if (a && b) begin
        state_reg <= ~state_reg;
    end else begin
        state_reg <= state_reg;
    end
end

assign q = (a == 0 && b == 1) || (a == 1 && b == 0) || (state_reg == 1 && b == 1);

endmodule