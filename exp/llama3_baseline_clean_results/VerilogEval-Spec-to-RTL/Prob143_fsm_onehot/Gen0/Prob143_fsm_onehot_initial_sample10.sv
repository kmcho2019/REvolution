module TopModule(
    input  in,
    input  [9:0] state,
    output [9:0] next_state,
    output out1,
    output out2
);

// Decode the current state into individual state signals
wire S0 = state[0];
wire S1 = state[1];
wire S2 = state[2];
wire S3 = state[3];
wire S4 = state[4];
wire S5 = state[5];
wire S6 = state[6];
wire S7 = state[7];
wire S8 = state[8];
wire S9 = state[9];

// Determine the next state
assign next_state[0] = (~in & (S0 | S1 | S2 | S3 | S4 | S5 | S8 | S9)) | (~in & S6) | (~in & S7);
assign next_state[1] = (in & S0) | (in & S8) | (in & S9) | (in & S7);
assign next_state[2] = (in & S1);
assign next_state[3] = (in & S2);
assign next_state[4] = (in & S3);
assign next_state[5] = (in & S4);
assign next_state[6] = (in & S5);
assign next_state[7] = (in & S6);
assign next_state[8] = (~in & S5);
assign next_state[9] = (~in & S6);

// Determine the output values
assign out1 = S8 | S9 | S7;
assign out2 = S7 | S9;

endmodule