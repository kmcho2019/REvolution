module TopModule (
    input clk,
    input a,
    input b,
    output q,
    output state
);

reg state_reg = 1'b0;

always @(posedge clk) begin
    if (a) state_reg <= ~state_reg;
end

assign q = state_reg ^ b;
assign state = state_reg;

endmodule