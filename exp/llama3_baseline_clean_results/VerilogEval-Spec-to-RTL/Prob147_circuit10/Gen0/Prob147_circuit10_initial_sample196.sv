module TopModule (
    input clk,
    input a,
    input b,
    output q,
    output state
);

reg state_reg;
assign state = state_reg;

always @(posedge clk) begin
    state_reg <= a;
end

assign q = (b == 1'b1) ? ~state_reg : 1'b0;

endmodule