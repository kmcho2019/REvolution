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
    if (a) begin
        state_reg <= 0;
    end
end

assign q = (state_reg) ? ~b : b;

endmodule