module TopModule(
    input in,
    input [9:0] state,
    output [9:0] next_state,
    output out1,
    output out2
);

    wire state_S0, state_S1, state_S2, state_S3, state_S4, state_S5, state_S6, state_S7, state_S8, state_S9;

    assign state_S0 = state[0];
    assign state_S1 = state[1];
    assign state_S2 = state[2];
    assign state_S3 = state[3];
    assign state_S4 = state[4];
    assign state_S5 = state[5];
    assign state_S6 = state[6];
    assign state_S7 = state[7];
    assign state_S8 = state[8];
    assign state_S9 = state[9];

    assign next_state[0] = (~in & (state_S0 | state_S1 | state_S2 | state_S3 | state_S4 | state_S5 | state_S6 | state_S7 | state_S8 | state_S9)) |
                          (~in & state_S7) | 
                          (~in & state_S8) | 
                          (~in & state_S9);
    assign next_state[1] = (in & state_S0) | 
                          (in & state_S1 & ~state_S7 & ~state_S8 & ~state_S9) | 
                          (in & state_S8) | 
                          (in & state_S9);
    assign next_state[2] = (in & state_S1) & ~state_S7 & ~state_S8 & ~state_S9;
    assign next_state[3] = (in & state_S2) & ~state_S7 & ~state_S8 & ~state_S9;
    assign next_state[4] = (in & state_S3) & ~state_S7 & ~state_S8 & ~state_S9;
    assign next_state[5] = (in & state_S4) & ~state_S7 & ~state_S8 & ~state_S9;
    assign next_state[6] = (in & state_S5) & ~state_S7 & ~state_S8 & ~state_S9;
    assign next_state[7] = (in & state_S6) & ~state_S7 & ~state_S8 & ~state_S9 | (in & state_S7);
    assign next_state[8] = (state_S5 & ~in) | (in & state_S0 & ~state_S5 & ~state_S7 & ~state_S9);
    assign next_state[9] = (state_S6 & ~in) | (in & state_S0 & ~state_S5 & ~state_S7 & ~state_S8);

    assign out1 = state_S8 | state_S9;
    assign out2 = state_S7 | state_S9;

endmodule