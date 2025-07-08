module TopModule(
    input         in,
    input  [9:0]  state,
    output [9:0]  next_state,
    output        out1,
    output        out2
);

    // Next state signals - one-hot encoding
    // For each active current state bit, determine next state(s) based on input 'in'
    wire [9:0] next_from_S0 = state[0] ? (in ? 10'b0000000010 : 10'b0000000001) : 10'b0; // S0->S1 if in=1 else S0
    wire [9:0] next_from_S1 = state[1] ? (in ? 10'b0000000100 : 10'b0000000001) : 10'b0; // S1->S2 if in=1 else S0
    wire [9:0] next_from_S2 = state[2] ? (in ? 10'b0000001000 : 10'b0000000001) : 10'b0; // S2->S3 if in=1 else S0
    wire [9:0] next_from_S3 = state[3] ? (in ? 10'b0000010000 : 10'b0000000001) : 10'b0; // S3->S4 if in=1 else S0
    wire [9:0] next_from_S4 = state[4] ? (in ? 10'b0000100000 : 10'b0000000001) : 10'b0; // S4->S5 if in=1 else S0
    wire [9:0] next_from_S5 = state[5] ? (in ? 10'b0000010000 : 10'b1000000000) : 10'b0; // S5->S6 if in=1 else S8
    wire [9:0] next_from_S6 = state[6] ? (in ? 10'b0100000000 : 10'b0010000000) : 10'b0; // S6->S7 if in=1 else S9
    wire [9:0] next_from_S7 = state[7] ? (in ? 10'b0000100000 : 10'b0000000001) : 10'b0; // S7->S7 if in=1 else S0
    wire [9:0] next_from_S8 = state[8] ? (in ? 10'b0000000010 : 10'b0000000001) : 10'b0; // S8->S1 if in=1 else S0
    wire [9:0] next_from_S9 = state[9] ? (in ? 10'b0000000010 : 10'b0000000001) : 10'b0; // S9->S1 if in=1 else S0

    // Combine all possible next states from all active current states
    assign next_state = next_from_S0 | next_from_S1 | next_from_S2 | next_from_S3 |
                        next_from_S4 | next_from_S5 | next_from_S6 | next_from_S7 |
                        next_from_S8 | next_from_S9;

    // Outputs depend on current state
    // out1 = 1 for S8 and S9 states active
    assign out1 = (state[8] | state[9]);

    // out2 = 1 for S7 and S9 states active
    assign out2 = (state[7] | state[9]);

endmodule