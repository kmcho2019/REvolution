module TopModule (
    input in,
    input [9:0] state,
    output [9:0] next_state,
    output out1,
    output out2
);

wire not_in = ~in;

// Simplified output logic
assign out1 = |state[9:8];  // S8 or S9
assign out2 = |state[9:7] & state[7];  // S7 or S9

// Simplified next state logic
assign next_state[0] = not_in & (|state[9:0] & ~(|state[6:5]));  // All states except S5/S6 when input=0
assign next_state[1] = in & (|{state[0], state[8:9]});
assign next_state[2] = in & state[1];
assign next_state[3] = in & state[2];
assign next_state[4] = in & state[3];
assign next_state[5] = in & state[4];
assign next_state[6] = in & state[5];
assign next_state[7] = in & (|state[6:7]);
assign next_state[8] = not_in & state[5];
assign next_state[9] = not_in & state[6];

endmodule