module TopModule (
    input  clk,
    input  a,
    input  b,
    output q,
    output state
);

reg state_reg; // register to hold the state

always @(posedge clk) begin
    state_reg <= b; // update state_reg on the positive edge of the clock
end

assign state = state_reg; // output state is the current value of state_reg
assign q = b; // output q is simply the input b

endmodule