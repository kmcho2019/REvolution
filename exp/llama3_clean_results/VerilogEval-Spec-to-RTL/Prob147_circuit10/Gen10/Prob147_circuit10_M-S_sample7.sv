module TopModule(
    input  clk,
    input  a,
    input  b,
    output q,
    output state
);

reg state_reg;
assign state = state_reg;

always @(posedge clk) begin
    if (~a && b) state_reg <= 1'b1;
    else if (a && b) state_reg <= 1'b0;
    // else, state_reg remains the same
end

assign q = state_reg || (b && ~state_reg);

endmodule