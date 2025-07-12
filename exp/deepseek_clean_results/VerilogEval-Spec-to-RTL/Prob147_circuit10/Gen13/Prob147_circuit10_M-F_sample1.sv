module TopModule (
    input clk,
    input a,
    input b,
    output q,
    output state
);

reg state_reg = 0;

always @(posedge clk) begin
    if (a ^ b) begin
        state_reg <= ~state_reg;
    end
end

assign state = state_reg;
assign q = (a == b) ? state_reg : ~state_reg;

endmodule