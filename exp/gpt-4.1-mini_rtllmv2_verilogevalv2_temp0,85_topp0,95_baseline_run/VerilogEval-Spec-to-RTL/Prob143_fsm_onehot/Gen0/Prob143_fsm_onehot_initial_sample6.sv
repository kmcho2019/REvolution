module TopModule (
    input        in,
    input  [9:0] state,
    output [9:0] next_state,
    output       out1,
    output       out2
);

    // Declare registers for next_state bits and outputs
    reg [9:0] next_state_r;
    reg       out1_r, out2_r;

    always @(*) begin
        // Default outputs and next_state are zero
        next_state_r = 10'b0;
        out1_r = 1'b0;
        out2_r = 1'b0;

        // Outputs depend only on current states
        // S7 (state[7]) sets out2=1
        if (state[7])
            out2_r = 1'b1;

        // S8 (state[8]) sets out1=1
        if (state[8])
            out1_r = 1'b1;

        // Compute next_state for each current active state

        // S0: state[0]
        // S0 --0--> S0
        if (state[0] && (in == 1'b0))
            next_state_r[0] = 1'b1;
        // S0 --1--> S1
        if (state[0] && (in == 1'b1))
            next_state_r[1] = 1'b1;

        // S1: state[1]
        // S1 --0--> S0
        if (state[1] && (in == 1'b0))
            next_state_r[0] = 1'b1;
        // S1 --1--> S2
        if (state[1] && (in == 1'b1))
            next_state_r[2] = 1'b1;

        // S2: state[2]
        // S2 --0--> S0
        if (state[2] && (in == 1'b0))
            next_state_r[0] = 1'b1;
        // S2 --1--> S3
        if (state[2] && (in == 1'b1))
            next_state_r[3] = 1'b1;

        // S3: state[3]
        // S3 --0--> S0
        if (state[3] && (in == 1'b0))
            next_state_r[0] = 1'b1;
        // S3 --1--> S4
        if (state[3] && (in == 1'b1))
            next_state_r[4] = 1'b1;

        // S4: state[4]
        // S4 --0--> S0
        if (state[4] && (in == 1'b0))
            next_state_r[0] = 1'b1;
        // S4 --1--> S5
        if (state[4] && (in == 1'b1))
            next_state_r[5] = 1'b1;

        // S5: state[5]
        // S5 --0--> S8
        if (state[5] && (in == 1'b0))
            next_state_r[8] = 1'b1;
        // S5 --1--> S6
        if (state[5] && (in == 1'b1))
            next_state_r[6] = 1'b1;

        // S6: state[6]
        // S6 --0--> S9
        if (state[6] && (in == 1'b0))
            next_state_r[9] = 1'b1;
        // S6 --1--> S7
        if (state[6] && (in == 1'b1))
            next_state_r[7] = 1'b1;

        // S7: state[7]
        // S7 --0--> S0
        if (state[7] && (in == 1'b0))
            next_state_r[0] = 1'b1;
        // S7 --1--> S7
        if (state[7] && (in == 1'b1))
            next_state_r[7] = 1'b1;

        // S8: state[8]
        // S8 --0--> S0
        if (state[8] && (in == 1'b0))
            next_state_r[0] = 1'b1;
        // S8 --1--> S1
        if (state[8] && (in == 1'b1))
            next_state_r[1] = 1'b1;

        // S9: state[9]
        // S9 --0--> S0
        if (state[9] && (in == 1'b0))
            next_state_r[0] = 1'b1;
        // S9 --1--> S1
        if (state[9] && (in == 1'b1))
            next_state_r[1] = 1'b1;
    end

    assign next_state = next_state_r;
    assign out1 = out1_r;
    assign out2 = out2_r;

endmodule