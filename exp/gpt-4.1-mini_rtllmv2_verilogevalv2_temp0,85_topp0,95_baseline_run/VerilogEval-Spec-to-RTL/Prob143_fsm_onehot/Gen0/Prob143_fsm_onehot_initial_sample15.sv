module TopModule(
    input         in,
    input  [9:0]  state,
    output [9:0]  next_state,
    output        out1,
    output        out2
);

    // Declare registers for next_state and outputs
    reg [9:0] ns;
    reg       o1, o2;

    integer i;

    always @(*) begin
        ns = 10'b0;
        o1 = 0;
        o2 = 0;

        // Check each state bit and compute transitions and outputs
        // S0 = state[0]
        if (state[0]) begin
            // S0 (0,0) --0--> S0
            if (in == 1'b0) ns[0] = 1'b1;
            else            ns[1] = 1'b1; // --1--> S1
            // outputs (0,0)
            // no output bits set
        end

        // S1 = state[1]
        if (state[1]) begin
            if (in == 1'b0) ns[0] = 1'b1; // --0--> S0
            else            ns[2] = 1'b1; // --1--> S2
            // outputs (0,0)
        end

        // S2 = state[2]
        if (state[2]) begin
            if (in == 1'b0) ns[0] = 1'b1; // --0--> S0
            else            ns[3] = 1'b1; // --1--> S3
            // outputs (0,0)
        end

        // S3 = state[3]
        if (state[3]) begin
            if (in == 1'b0) ns[0] = 1'b1; // --0--> S0
            else            ns[4] = 1'b1; // --1--> S4
            // outputs (0,0)
        end

        // S4 = state[4]
        if (state[4]) begin
            if (in == 1'b0) ns[0] = 1'b1; // --0--> S0
            else            ns[5] = 1'b1; // --1--> S5
            // outputs (0,0)
        end

        // S5 = state[5]
        if (state[5]) begin
            if (in == 1'b0) ns[8] = 1'b1; // --0--> S8
            else            ns[6] = 1'b1; // --1--> S6
            // outputs (0,0)
        end

        // S6 = state[6]
        if (state[6]) begin
            if (in == 1'b0) ns[9] = 1'b1; // --0--> S9
            else            ns[7] = 1'b1; // --1--> S7
            // outputs (0,0)
        end

        // S7 = state[7]
        if (state[7]) begin
            if (in == 1'b0) ns[0] = 1'b1; // --0--> S0
            else            ns[7] = 1'b1; // --1--> S7
            // outputs (0,1)
            o2 = 1'b1;
        end

        // S8 = state[8]
        if (state[8]) begin
            if (in == 1'b0) ns[0] = 1'b1; // --0--> S0
            else            ns[1] = 1'b1; // --1--> S1
            // outputs (1,0)
            o1 = 1'b1;
        end

        // S9 = state[9]
        if (state[9]) begin
            if (in == 1'b0) ns[0] = 1'b1; // --0--> S0
            else            ns[1] = 1'b1; // --1--> S1
            // outputs (1,1)
            o1 = 1'b1;
            o2 = 1'b1;
        end
    end

    assign next_state = ns;
    assign out1 = o1;
    assign out2 = o2;

endmodule