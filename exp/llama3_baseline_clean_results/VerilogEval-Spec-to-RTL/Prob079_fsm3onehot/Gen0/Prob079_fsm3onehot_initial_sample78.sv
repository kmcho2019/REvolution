module TopModule(
    input in,
    input [3:0] state,
    output [3:0] next_state,
    output out
);

// Next state logic
assign next_state = (in == 0) ? 
    ({state[0] && 1'b1, state[1] && 1'b0, state[2] && 1'b1, state[3] && 1'b1}) : 
    ({state[0] && 1'b1, state[1] && (1'b1 || state[2] || state[3]), state[2] && 1'b0, state[3] && 1'b1});

// Output logic
assign out = state[3];  // output is 1 when state is D (4'b1000)

endmodule