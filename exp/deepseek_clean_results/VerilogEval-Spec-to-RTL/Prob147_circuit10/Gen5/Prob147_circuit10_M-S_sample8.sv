module TopModule (
    input clk,
    input a,
    input b,
    output q,
    output state
);

reg state_reg = 0;

always @(posedge clk) begin
    state_reg <= a;
end

assign q = b ^ state_reg;
assign state = state_reg;

endmodule