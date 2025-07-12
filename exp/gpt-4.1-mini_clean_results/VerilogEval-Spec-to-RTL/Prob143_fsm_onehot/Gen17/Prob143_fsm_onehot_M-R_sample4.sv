module TopModule(
    input        in,
    input  [9:0] state,
    output [9:0] next_state,
    output       out1,
    output       out2
);

    genvar i;
    // Declare next_state as reg for generate assignment
    reg [9:0] ns;

    // Combinational logic for next_state using always @* and generate-for
    always @* begin
        ns = 10'b0;

        // S0 transitions
        if (state[0]) begin
            ns[0] = ~in;
            ns[1] = in;
        end
        // S1 transitions
        if (state[1]) begin
            ns[0] = ns[0] | ~in;
            ns[2] = ns[2] | in;
        end
        // S2 transitions
        if (state[2]) begin
            ns[0] = ns[0] | ~in;
            ns[3] = ns[3] | in;
        end
        // S3 transitions
        if (state[3]) begin
            ns[0] = ns[0] | ~in;
            ns[4] = ns[4] | in;
        end
        // S4 transitions
        if (state[4]) begin
            ns[0] = ns[0] | ~in;
            ns[5] = ns[5] | in;
        end
        // S5 transitions
        if (state[5]) begin
            ns[8] = ns[8] | ~in;
            ns[6] = ns[6] | in;
        end
        // S6 transitions
        if (state[6]) begin
            ns[9] = ns[9] | ~in;
            ns[7] = ns[7] | in;
        end
        // S7 transitions
        if (state[7]) begin
            ns[0] = ns[0] | ~in;
            ns[7] = ns[7] | in;
        end
        // S8 transitions
        if (state[8]) begin
            ns[0] = ns[0] | ~in;
            ns[1] = ns[1] | in;
        end
        // S9 transitions
        if (state[9]) begin
            ns[0] = ns[0] | ~in;
            ns[1] = ns[1] | in;
        end
    end

    assign next_state = ns;

    // Output logic from states (out1, out2)
    // According to the problem, out1 = 1 when state 8 or 9 active
    // out2 = 1 when state 7 or 9 active
    assign out1 = state[8] | state[9];
    assign out2 = state[7] | state[9];

endmodule