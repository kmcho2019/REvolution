module TopModule (
    input clk,
    input a,
    input b,
    output q,
    output state
);

reg state_reg = 1'b0;

always @(posedge clk) begin
    if (a & b)         // Toggle condition
        state_reg <= ~state_reg;
end

assign q = b ? state_reg : 1'b0;  // Output follows state when b is high
assign state = state_reg;

endmodule