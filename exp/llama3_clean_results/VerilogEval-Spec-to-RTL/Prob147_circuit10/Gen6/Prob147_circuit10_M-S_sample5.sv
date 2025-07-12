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
    if (~a && b)
        state_reg <= 1'b1;
    else if (a && b)
        state_reg <= 1'b0;
    // No else needed, state_reg remains the same for other conditions
end

assign q = b || (state_reg && a);

endmodule