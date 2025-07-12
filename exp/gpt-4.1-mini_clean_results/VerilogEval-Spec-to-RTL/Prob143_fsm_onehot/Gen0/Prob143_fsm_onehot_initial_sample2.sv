module TopModule (
    input        in,
    input  [9:0] state,
    output [9:0] next_state,
    output       out1,
    output       out2
);

    wire [9:0] ns;
    
    // For each state, if active, determine next state based on input
    assign ns[0] = (state[0] & ~in) | (state[1] & ~in) | (state[2] & ~in) | (state[3] & ~in) | (state[4] & ~in)
                 | (state[7] & ~in) | (state[8] & ~in) | (state[9] & ~in);
    assign ns[1] = (state[0] &  in) | (state[9] &  in) | (state[8] &  in);
    assign ns[2] = (state[1] &  in);
    assign ns[3] = (state[2] &  in);
    assign ns[4] = (state[3] &  in);
    assign ns[5] = (state[4] &  in);
    assign ns[6] = (state[5] &  in);
    assign ns[7] = (state[6] &  in) | (state[7] &  in);
    assign ns[8] = (state[5] & ~in);
    assign ns[9] = (state[6] & ~in);
    
    assign next_state = ns;
    
    // Outputs
    // S7 (state[7]) => out2=1
    // S8 (state[8]) => out1=1
    // S9 (state[9]) => out1=1, out2=1
    assign out1 = (state[8]) | (state[9]);
    assign out2 = (state[7]) | (state[9]);

endmodule