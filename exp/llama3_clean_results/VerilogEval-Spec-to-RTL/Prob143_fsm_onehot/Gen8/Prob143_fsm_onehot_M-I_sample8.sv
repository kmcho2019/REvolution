module TopModule(
    input in,
    input [9:0] state,
    output [9:0] next_state,
    output out1,
    output out2
);

    wire [9:0] next_state_reg;
    wire out1_reg;
    wire out2_reg;

    assign next_state_reg[0] = (~in & (state[0] | state[1] | state[2] | state[3] | state[4] | state[5] | state[7] | state[8] | state[9]));
    assign next_state_reg[1] = (in & (state[0] | state[8] | state[9]));
    assign next_state_reg[2] = (in & state[1]);
    assign next_state_reg[3] = (in & state[2]);
    assign next_state_reg[4] = (in & state[3]);
    assign next_state_reg[5] = (in & state[4]);
    assign next_state_reg[6] = (in & state[5]);
    assign next_state_reg[7] = (in & state[6]);
    assign next_state_reg[8] = (~in & state[5]);
    assign next_state_reg[9] = (~in & state[6]);

    assign out1_reg = (state[8] | state[9]);
    assign out2_reg = state[7];

    assign next_state = next_state_reg;
    assign out1 = out1_reg;
    assign out2 = out2_reg;

endmodule