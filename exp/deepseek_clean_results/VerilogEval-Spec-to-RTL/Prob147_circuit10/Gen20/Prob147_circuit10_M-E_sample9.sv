module TopModule (
    input clk,
    input a,
    input b,
    output q,
    output state
);

reg state_reg = 0;

always @(posedge clk) begin
    if ((a ^ b) & ~state_reg) begin
        state_reg <= ~state_reg;
    end
    else if (~(a ^ b) & state_reg) begin
        state_reg <= ~state_reg;
    end
end

assign q = (a | b) ? state_reg : 1'b0;
assign state = state_reg;

endmodule