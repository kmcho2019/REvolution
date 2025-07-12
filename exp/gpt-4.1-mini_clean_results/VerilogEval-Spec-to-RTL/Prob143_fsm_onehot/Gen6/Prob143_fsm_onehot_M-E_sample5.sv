module TopModule(
    input        in,
    input  [9:0] state,
    output [9:0] next_state,
    output       out1,
    output       out2
);

    // Each state's next state vector contribution
    // For each state i active, form a one-hot next state vector based on 'in' input

    wire [9:0] ns_from_s0 = state[0] ? (in ? 10'b0000000010 : 10'b0000000001) : 10'b0; // S0->S1 on in=1, else S0
    wire [9:0] ns_from_s1 = state[1] ? (in ? 10'b0000000100 : 10'b0000000001) : 10'b0; // S1->S2 on in=1, else S0
    wire [9:0] ns_from_s2 = state[2] ? (in ? 10'b0000001000 : 10'b0000000001) : 10'b0; // S2->S3 on in=1, else S0
    wire [9:0] ns_from_s3 = state[3] ? (in ? 10'b0000010000 : 10'b0000000001) : 10'b0; // S3->S4 on in=1, else S0
    wire [9:0] ns_from_s4 = state[4] ? (in ? 10'b0000100000 : 10'b0000000001) : 10'b0; // S4->S5 on in=1, else S0
    wire [9:0] ns_from_s5 = state[5] ? (in ? 10'b0000010000 : 10'b0001000000) : 10'b0; // S5->S6(in=1), S8(in=0)
    wire [9:0] ns_from_s6 = state[6] ? (in ? 10'b0100000000 : 10'b1000000000) : 10'b0; // S6->S7(in=1), S9(in=0)
    wire [9:0] ns_from_s7 = state[7] ? (in ? 10'b1000000000 : 10'b0000000001) : 10'b0; // S7->S7(in=1), S0(in=0)
    wire [9:0] ns_from_s8 = state[8] ? (in ? 10'b0000000010 : 10'b0000000001) : 10'b0; // S8->S1(in=1), S0(in=0)
    wire [9:0] ns_from_s9 = state[9] ? (in ? 10'b0000000010 : 10'b0000000001) : 10'b0; // S9->S1(in=1), S0(in=0)

    assign next_state = ns_from_s0 | ns_from_s1 | ns_from_s2 | ns_from_s3 | ns_from_s4 |
                        ns_from_s5 | ns_from_s6 | ns_from_s7 | ns_from_s8 | ns_from_s9;

    // Outputs depend on current states only, with given values
    assign out1 = (state[8] | state[9]);
    assign out2 = (state[7] | state[9]);

endmodule