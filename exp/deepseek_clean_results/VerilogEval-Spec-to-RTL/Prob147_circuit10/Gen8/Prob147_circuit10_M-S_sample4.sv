module TopModule (
    input clk,
    input a,
    input b,
    output q,
    output state
);

reg state_reg = 0;

always @(posedge clk) begin
    state_reg <= a & b;  // Set state only when both inputs are high
end

assign q = state_reg;
assign state = state_reg;

endmodule