module TopModule(
    input  clk,
    input  a,
    input  b,
    output q,
    output state
);

reg state_reg;

always @(posedge clk) begin
    if (b == 1 && a == 1) begin
        state_reg <= 0;
    end else if (b == 0) begin
        state_reg <= a;
    end
end

assign state = state_reg;
assign q = (b == 1) ? ~state_reg : state_reg;

endmodule