module TopModule (
    input in,
    input [9:0] state,
    output [9:0] next_state,
    output out1,
    output out2
);

// Priority encoder to find highest priority active state
wire [9:0] priority_state;
assign priority_state[9] = state[9];
assign priority_state[8] = state[8] & ~state[9];
assign priority_state[7] = state[7] & ~|state[9:8];
assign priority_state[6] = state[6] & ~|state[9:7];
assign priority_state[5] = state[5] & ~|state[9:6];
assign priority_state[4] = state[4] & ~|state[9:5];
assign priority_state[3] = state[3] & ~|state[9:4];
assign priority_state[2] = state[2] & ~|state[9:3];
assign priority_state[1] = state[1] & ~|state[9:2];
assign priority_state[0] = state[0] & ~|state[9:1];

// Transition logic based on highest priority state
assign next_state[0] = (~in & (|state[9:0])) | 
                       (in & priority_state[0]) |
                       (~in & (priority_state[1] | priority_state[2] | 
                              priority_state[3] | priority_state[4] | 
                              priority_state[7] | priority_state[8] | 
                              priority_state[9]));

assign next_state[1] = in & (priority_state[0] | priority_state[8] | priority_state[9]);
assign next_state[2] = in & priority_state[1];
assign next_state[3] = in & priority_state[2];
assign next_state[4] = in & priority_state[3];
assign next_state[5] = in & priority_state[4];
assign next_state[6] = in & priority_state[5];
assign next_state[7] = in & (priority_state[6] | priority_state[7]);
assign next_state[8] = ~in & priority_state[5];
assign next_state[9] = ~in & priority_state[6];

// Output logic based on highest priority state
assign out1 = priority_state[8] | priority_state[9];
assign out2 = priority_state[7] | priority_state[9];

endmodule