module TopModule (
    input in,
    input [3:0] state,
    output [3:0] next_state,
    output out
);

    wire not_in = ~in;
    wire state_c = state[2];
    
    assign next_state[0] = not_in & (state[0] | state_c);
    assign next_state[1] = in & ~state_c;
    assign next_state[2] = not_in & (state[1] | state[3]);
    assign next_state[3] = in & state_c;
    
    assign out = state[3];

endmodule