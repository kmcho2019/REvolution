module TopModule(
    input        in,
    input  [9:0] state,
    output reg [9:0] next_state,
    output reg       out1,
    output reg       out2
);

always @(*) begin
    // Initialize outputs and next_state
    next_state = 10'b0;
    out1 = 1'b0;
    out2 = 1'b0;

    // Transition and output logic for each active state
    if (state[0]) begin // S0 (0,0)
        if (in == 1'b0) next_state[0] = 1'b1; // S0 --0--> S0
        else            next_state[1] = 1'b1; // S0 --1--> S1
    end

    if (state[1]) begin // S1 (0,0)
        if (in == 1'b0) next_state[0] = 1'b1; // S1 --0--> S0
        else            next_state[2] = 1'b1; // S1 --1--> S2
    end

    if (state[2]) begin // S2 (0,0)
        if (in == 1'b0) next_state[0] = 1'b1; // S2 --0--> S0
        else            next_state[3] = 1'b1; // S2 --1--> S3
    end

    if (state[3]) begin // S3 (0,0)
        if (in == 1'b0) next_state[0] = 1'b1; // S3 --0--> S0
        else            next_state[4] = 1'b1; // S3 --1--> S4
    end

    if (state[4]) begin // S4 (0,0)
        if (in == 1'b0) next_state[0] = 1'b1; // S4 --0--> S0
        else            next_state[5] = 1'b1; // S4 --1--> S5
    end

    if (state[5]) begin // S5 (0,0)
        if (in == 1'b0) next_state[8] = 1'b1; // S5 --0--> S8
        else            next_state[6] = 1'b1; // S5 --1--> S6
    end

    if (state[6]) begin // S6 (0,0)
        if (in == 1'b0) next_state[9] = 1'b1; // S6 --0--> S9
        else            next_state[7] = 1'b1; // S6 --1--> S7
    end

    if (state[7]) begin // S7 (0,1)
        if (in == 1'b0) next_state[0] = 1'b1; // S7 --0--> S0
        else            next_state[7] = 1'b1; // S7 --1--> S7
        out2 = 1'b1;
    end

    if (state[8]) begin // S8 (1,0)
        if (in == 1'b0) next_state[0] = 1'b1; // S8 --0--> S0
        else            next_state[1] = 1'b1; // S8 --1--> S1
        out1 = 1'b1;
    end

    if (state[9]) begin // S9 (1,1)
        if (in == 1'b0) next_state[0] = 1'b1; // S9 --0--> S0
        else            next_state[1] = 1'b1; // S9 --1--> S1
        out1 = 1'b1;
        out2 = 1'b1;
    end
end

endmodule