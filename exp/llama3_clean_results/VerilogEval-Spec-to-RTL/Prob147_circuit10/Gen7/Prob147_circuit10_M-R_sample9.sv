module TopModule(
    input clk,
    input a,
    input b,
    output q,
    output state
);

reg state_reg;
assign state = state_reg;
assign q = (state_reg || (a && ~b));

always @(posedge clk) begin
    if (a && b) begin
        state_reg <= ~state_reg;
    end else if (~a && b) begin
        state_reg <= 1'b1;
    end else begin
        state_reg <= state_reg;
    end
end

endmodule