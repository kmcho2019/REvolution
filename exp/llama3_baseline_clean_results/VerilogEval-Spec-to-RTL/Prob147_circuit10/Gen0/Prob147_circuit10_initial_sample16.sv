module TopModule(
    input clk,
    input a,
    input b,
    output q,
    output state
);

reg state_reg;
assign state = state_reg;
assign q = b | state_reg;

always @(posedge clk) begin
    if (a) begin
        state_reg <= 0;
    end else if (b) begin
        state_reg <= 1;
    end
end

endmodule