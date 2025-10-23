module TopModule(
    input        in,
    input  [9:0] state,
    output [9:0] next_state,
    output       out1,
    output       out2
);

    // Intermediate next state vectors from each state for input=0 and input=1
    wire [9:0] next0_from_S [0:9];
    wire [9:0] next1_from_S [0:9];

    // Define all possible next states for input=0 from each current state
    assign next0_from_S[0] = 10'b0000000001; // S0 --0--> S0
    assign next0_from_S[1] = 10'b0000000001; // S1 --0--> S0
    assign next0_from_S[2] = 10'b0000000001; // S2 --0--> S0
    assign next0_from_S[3] = 10'b0000000001; // S3 --0--> S0
    assign next0_from_S[4] = 10'b0000000001; // S4 --0--> S0
    assign next0_from_S[5] = 10'b1000000000; // S5 --0--> S8
    assign next0_from_S[6] = 10'b0100000000; // S6 --0--> S9
    assign next0_from_S[7] = 10'b0000000001; // S7 --0--> S0
    assign next0_from_S[8] = 10'b0000000001; // S8 --0--> S0
    assign next0_from_S[9] = 10'b0000000001; // S9 --0--> S0

    // Define all possible next states for input=1 from each current state
    assign next1_from_S[0] = 10'b0000000010; // S0 --1--> S1
    assign next1_from_S[1] = 10'b0000000100; // S1 --1--> S2
    assign next1_from_S[2] = 10'b0000001000; // S2 --1--> S3
    assign next1_from_S[3] = 10'b0000010000; // S3 --1--> S4
    assign next1_from_S[4] = 10'b0000100000; // S4 --1--> S5
    assign next1_from_S[5] = 10'b0001000000; // S5 --1--> S6
    assign next1_from_S[6] = 10'b0010000000; // S6 --1--> S7
    assign next1_from_S[7] = 10'b0000000010; // S7 --1--> S7 (self-loop)
    assign next1_from_S[8] = 10'b0000000010; // S8 --1--> S1
    assign next1_from_S[9] = 10'b0000000010; // S9 --1--> S1

    // For each state bit, select corresponding next state vector based on input
    wire [9:0] next_from_state [0:9];
    genvar i;
    generate
        for (i=0; i<10; i=i+1) begin : gen_next_from_state
            assign next_from_state[i] = state[i] ? (in ? next1_from_S[i] : next0_from_S[i]) : 10'b0;
        end
    endgenerate

    // OR together all next_from_state to get final next_state
    assign next_state = next_from_state[0] | next_from_state[1] | next_from_state[2] |
                        next_from_state[3] | next_from_state[4] | next_from_state[5] |
                        next_from_state[6] | next_from_state[7] | next_from_state[8] |
                        next_from_state[9];

    // Outputs according to state encoding
    assign out1 = state[8] | state[9];
    assign out2 = state[7] | state[9];

endmodule