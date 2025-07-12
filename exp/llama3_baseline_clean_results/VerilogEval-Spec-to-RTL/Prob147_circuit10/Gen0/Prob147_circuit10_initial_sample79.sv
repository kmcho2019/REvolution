module TopModule(
    input clk,
    input a,
    input b,
    output q,
    output state
);

reg state_reg; // internal register for state
assign state = state_reg; // output state

always @(posedge clk) // update state on positive edge of clock
begin
    if (a == 1 && b == 1)
        state_reg <= ~state_reg; // toggle state when a=1 and b=1
    else
        state_reg <= state_reg; // keep state the same when a=0 or b=0
end

assign q = (b == 0)? state_reg : ~state_reg; // output q based on b and state

endmodule