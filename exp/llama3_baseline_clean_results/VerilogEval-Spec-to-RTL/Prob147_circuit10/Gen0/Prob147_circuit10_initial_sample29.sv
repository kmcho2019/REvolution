module TopModule(
    input clk,
    input a,
    input b,
    output q,
    output state
);

reg state_reg; // 1-bit flip-flop
assign state = state_reg; // make the state of the flip-flop observable

always @ (posedge clk)
begin
    if (~a & ~b) // if both a and b are 0
        state_reg <= 0;
    else if (a & ~b) // if a is 1 and b is 0
        state_reg <= state_reg;
    else if (~a & b) // if a is 0 and b is 1
        state_reg <= 0;
    else // if both a and b are 1
        state_reg <= ~state_reg; // toggle the state
end

assign q = (a ^ b) | (~a & ~b & state_reg); // compute the output q based on the current state and inputs

endmodule