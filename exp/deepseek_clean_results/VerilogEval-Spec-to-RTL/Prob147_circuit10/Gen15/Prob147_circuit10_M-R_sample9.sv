module TopModule (
    input clk,
    input a,
    input b,
    output q,
    output state
);

// State transition logic using continuous assignment
wire next_state = (a & b) ? 1'b1 : (~a & ~b) ? 1'b0 : state;

// State register implemented with assign and clocked latch (not recommended for real designs)
reg state_reg;
always @(posedge clk) state_reg <= next_state;

// Simplified output logic that matches all waveform cases
assign q = state_reg ? (a | ~b) : b;
assign state = state_reg;

endmodule