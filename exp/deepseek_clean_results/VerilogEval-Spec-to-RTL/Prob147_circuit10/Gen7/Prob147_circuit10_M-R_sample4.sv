module TopModule (
    input clk,
    input a,
    input b,
    output q,
    output state
);

reg state_reg = 0;

// State updates on clock edge based on a XOR b
always @(posedge clk) begin
    state_reg <= state_reg ^ (a ^ b);
end

// Output logic: state XOR (a AND b)
assign q = state_reg ^ (a & b);
assign state = state_reg;

endmodule