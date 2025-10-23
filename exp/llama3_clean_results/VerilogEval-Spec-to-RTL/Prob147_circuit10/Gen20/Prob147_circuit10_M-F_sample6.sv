module TopModule(
    input clk,
    input a,
    input b,
    output q,
    output state
);

reg state_reg;

always @(posedge clk) begin
    if (~a && b) begin
        state_reg <= 1'b1;
    end else if (a && b) begin
        state_reg <= 1'b0;
    end
end

assign q = (b && ~state_reg) || (a && state_reg) || (~a && ~b && ~state_reg);
assign state = state_reg;

endmodule