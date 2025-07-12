module TopModule(
    input  in,
    input  [9:0] state,
    output [9:0] next_state,
    output out1,
    output out2
);

    assign next_state = 10'b0; // default next state to all zeros
    assign out1 = 1'b0; // default out1 to 0
    assign out2 = 1'b0; // default out2 to 0

    // prioritize states with higher indices
    if (state[9]) begin // S9
        assign next_state[0] = in ? 1'b1 : 1'b1;
        assign next_state[1] = in ? 1'b1 : 1'b0;
        assign out1 = 1'b1;
        assign out2 = 1'b1;
    end else if (state[8]) begin // S8
        assign next_state[0] = in ? 1'b1 : 1'b1;
        assign next_state[1] = in ? 1'b1 : 1'b0;
        assign out1 = 1'b1;
    end else if (state[7]) begin // S7
        assign next_state[7] = in ? 1'b1 : 1'b0;
        assign next_state[0] = in ? 1'b0 : 1'b1;
        assign out1 = in ? 1'b0 : 1'b0;
        assign out2 = in ? 1'b1 : 1'b1;
    end else if (state[6]) begin // S6
        assign next_state[9] = in ? 1'b0 : 1'b1;
        assign next_state[6] = in ? 1'b0 : 1'b0;
        assign next_state[7] = in ? 1'b1 : 1'b0;
    end else if (state[5]) begin // S5
        assign next_state[8] = in ? 1'b0 : 1'b1;
        assign next_state[5] = in ? 1'b0 : 1'b0;
        assign next_state[6] = in ? 1'b1 : 1'b0;
    end else if (state[4]) begin // S4
        assign next_state[5] = in ? 1'b1 : 1'b0;
        assign next_state[0] = in ? 1'b0 : 1'b1;
    end else if (state[3]) begin // S3
        assign next_state[4] = in ? 1'b1 : 1'b0;
        assign next_state[0] = in ? 1'b0 : 1'b1;
    end else if (state[2]) begin // S2
        assign next_state[3] = in ? 1'b1 : 1'b0;
        assign next_state[0] = in ? 1'b0 : 1'b1;
    end else if (state[1]) begin // S1
        assign next_state[2] = in ? 1'b1 : 1'b0;
        assign next_state[0] = in ? 1'b0 : 1'b1;
    end else if (state[0]) begin // S0
        assign next_state[1] = in ? 1'b1 : 1'b0;
        assign next_state[0] = in ? 1'b0 : 1'b1;
    end

endmodule