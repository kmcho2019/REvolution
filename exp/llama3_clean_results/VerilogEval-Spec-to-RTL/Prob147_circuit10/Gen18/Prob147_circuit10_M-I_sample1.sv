module TopModule(
    input clk,
    input a,
    input b,
    output q,
    output state
);

reg state_reg = 1'b0;

always @(posedge clk) begin
    if (~a && b) begin
        state_reg <= 1'b1;
    end else if (a && b) begin
        state_reg <= 1'b0;
    end
end

assign q = state_reg || (a && ~b);
assign state = state_reg;

endmodule