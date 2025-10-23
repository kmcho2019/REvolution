module TopModule(
    input clk,
    input a,
    input b,
    output q,
    output state
);

reg state_reg; // internal register to hold the state of the flip-flop
assign state = state_reg; // drive the state output with the internal register

always @(posedge clk) // update the state at the positive edge of the clock
    state_reg <= (b == 0 && a == 0) || (b == 1 && state_reg == 1) ? 1 : 0;

assign q = (b == 0 && (state_reg == 1 || a == 1)) || (b == 1 && a == 0 && state_reg == 0);

endmodule