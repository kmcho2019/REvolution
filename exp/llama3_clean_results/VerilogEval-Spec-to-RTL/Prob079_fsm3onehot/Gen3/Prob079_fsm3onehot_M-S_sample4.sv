module TopModule(
    input in,
    input [3:0] state,
    output [3:0] next_state,
    output out
);

assign next_state = (
    (~state[3] & ~state[2] & ~state[1] & state[0]) ? (in ? 4'b0010 : 4'b0001) : // A
    (~state[3] & ~state[2] & state[1] & ~state[0]) ? (in ? 4'b0010 : 4'b0100) : // B
    (~state[3] & state[2] & ~state[1] & ~state[0]) ? (in ? 4'b1000 : 4'b0001) : // C
    (state[3] & ~state[2] & ~state[1] & ~state[0]) ? (in ? 4'b0010 : 4'b0100) : // D
    4'b0000 // default next state
);

assign out = state[3];

endmodule