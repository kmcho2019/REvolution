module TopModule (
    input  in,
    input  [3:0] state,
    output [3:0] next_state,
    output out
);
    // For each next_state bit, select next state based on input 'in'
    assign next_state[0] = (in == 1'b0) ? (state[0] | state[2]) : 1'b0;          // A: from A or C if in=0, else 0
    assign next_state[1] = (in == 1'b0) ? state[2] : (state[0] | state[1] | state[3]); // B: from C if in=0, else A,B,D
    assign next_state[2] = (in == 1'b0) ? state[1] : state[3];                   // C: from B if in=0, else D
    assign next_state[3] = (in == 1'b0) ? 1'b0 : state[2];                       // D: from 0 if in=0, else C

    // Output is high only when current state is D
    assign out = state[3];

endmodule