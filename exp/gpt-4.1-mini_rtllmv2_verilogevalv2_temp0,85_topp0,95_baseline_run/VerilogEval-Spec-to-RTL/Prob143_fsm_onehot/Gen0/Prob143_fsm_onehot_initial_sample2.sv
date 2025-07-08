module TopModule (
    input  wire        in,
    input  wire [9:0]  state,
    output wire [9:0]  next_state,
    output wire        out1,
    output wire        out2
);

    // Initialize all next_state bits to zero
    reg [9:0] ns;

    always @(*) begin
        ns = 10'b0;

        // S0 transitions
        if (state[0]) begin
            if (in == 1'b0) ns[0] = 1'b1; // stay S0
            else           ns[1] = 1'b1; // go to S1
        end

        // S1 transitions
        if (state[1]) begin
            if (in == 1'b0) ns[0] = 1'b1; // S0
            else           ns[2] = 1'b1; // S2
        end

        // S2 transitions
        if (state[2]) begin
            if (in == 1'b0) ns[0] = 1'b1; // S0
            else           ns[3] = 1'b1; // S3
        end

        // S3 transitions
        if (state[3]) begin
            if (in == 1'b0) ns[0] = 1'b1; // S0
            else           ns[4] = 1'b1; // S4
        end

        // S4 transitions
        if (state[4]) begin
            if (in == 1'b0) ns[0] = 1'b1; // S0
            else           ns[5] = 1'b1; // S5
        end

        // S5 transitions
        if (state[5]) begin
            if (in == 1'b0) ns[8] = 1'b1; // S8
            else           ns[6] = 1'b1; // S6
        end

        // S6 transitions
        if (state[6]) begin
            if (in == 1'b0) ns[9] = 1'b1; // S9
            else           ns[7] = 1'b1; // S7
        end

        // S7 transitions
        if (state[7]) begin
            if (in == 1'b0) ns[0] = 1'b1; // S0
            else           ns[7] = 1'b1; // stay S7
        end

        // S8 transitions
        if (state[8]) begin
            if (in == 1'b0) ns[0] = 1'b1; // S0
            else           ns[1] = 1'b1; // S1
        end

        // S9 transitions
        if (state[9]) begin
            if (in == 1'b0) ns[0] = 1'b1; // S0
            else           ns[1] = 1'b1; // S1
        end
    end

    assign next_state = ns;

    // Outputs: out1=1 when in S8; out2=1 when in S7; otherwise zero
    assign out1 = state[8];
    assign out2 = state[7];

endmodule