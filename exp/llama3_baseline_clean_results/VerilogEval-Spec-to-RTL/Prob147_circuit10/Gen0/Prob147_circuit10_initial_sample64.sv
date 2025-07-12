module TopModule(
    input  clk,
    input  a,
    input  b,
    output q,
    output state
);

reg state_reg;

initial begin
    state_reg = 0;
end

always @(posedge clk) begin
    if (b == 1) begin
        state_reg <= a;
    end
end

assign state = state_reg;

assign q = (b == 1 && state_reg == 0) || (state_reg == 1 && b == 1);

endmodule