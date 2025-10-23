module TopModule(
    input        in,
    input  [9:0] state,
    output [9:0] next_state,
    output       out1,
    output       out2
);

    wire zero_in = ~in;
    wire one_in  =  in;

    // Next states contributed by each active state bit
    wire [9:0] ns_from_S0 = state[0] ? ( (zero_in ? 10'b0000000001 : 10'b0000000010) ) : 10'b0;
    wire [9:0] ns_from_S1 = state[1] ? ( (zero_in ? 10'b0000000001 : 10'b0000000100) ) : 10'b0;
    wire [9:0] ns_from_S2 = state[2] ? ( (zero_in ? 10'b0000000001 : 10'b0000010000) ) : 10'b0;
    wire [9:0] ns_from_S3 = state[3] ? ( (zero_in ? 10'b0000000001 : 10'b0000100000) ) : 10'b0;
    wire [9:0] ns_from_S4 = state[4] ? ( (zero_in ? 10'b0000000001 : 10'b0001000000) ) : 10'b0;
    wire [9:0] ns_from_S5 = state[5] ? ( (zero_in ? 10'b0010000000 : 10'b0000001000) ) : 10'b0;
    wire [9:0] ns_from_S6 = state[6] ? ( (zero_in ? 10'b0100000000 : 10'b1000000000) ) : 10'b0;
    wire [9:0] ns_from_S7 = state[7] ? ( (zero_in ? 10'b0000000001 : 10'b0000100000) ) : 10'b0;
    wire [9:0] ns_from_S8 = state[8] ? ( (zero_in ? 10'b0000000001 : 10'b0000000010) ) : 10'b0;
    wire [9:0] ns_from_S9 = state[9] ? ( (zero_in ? 10'b0000000001 : 10'b0000000010) ) : 10'b0;

    // Combine all next state contributions
    assign next_state = ns_from_S0 |
                        ns_from_S1 |
                        ns_from_S2 |
                        ns_from_S3 |
                        ns_from_S4 |
                        ns_from_S5 |
                        ns_from_S6 |
                        ns_from_S7 |
                        ns_from_S8 |
                        ns_from_S9;

    // Outputs: only S7, S8, S9 have nonzero outputs
    assign out1 = state[8] | state[9];       // S8 and S9 activate out1
    assign out2 = state[7] | state[9];       // S7 and S9 activate out2

endmodule