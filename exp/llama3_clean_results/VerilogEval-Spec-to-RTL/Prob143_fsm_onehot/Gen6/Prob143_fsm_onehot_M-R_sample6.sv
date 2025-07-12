module TopModule(
    input in,
    input [9:0] state,
    output [9:0] next_state,
    output out1,
    output out2
);

    // Directly implement next state logic
    assign next_state[0] = (~in & (state[0] | state[1] | state[2] | state[3] | state[4] | state[7] | state[8] | state[9]))? 1'b1 : 1'b0;
    assign next_state[1] = (~in & (state[8] | state[9])) | (in & state[0])? 1'b1 : 1'b0;
    assign next_state[2] = (in & state[1])? 1'b1 : 1'b0;
    assign next_state[3] = (in & state[2])? 1'b1 : 1'b0;
    assign next_state[4] = (in & state[3])? 1'b1 : 1'b0;
    assign next_state[5] = (in & state[4])? 1'b1 : 1'b0;
    assign next_state[6] = (in & state[5])? 1'b1 : 1'b0;
    assign next_state[7] = (in & state[6]) | (in & state[7])? 1'b1 : 1'b0;
    assign next_state[8] = (~in & state[5])? 1'b1 : 1'b0;
    assign next_state[9] = (~in & state[6])? 1'b1 : 1'b0;

    // Directly implement output logic
    assign out1 = state[8] | state[9];
    assign out2 = state[7] | state[9];

endmodule