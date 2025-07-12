module TopModule (
    input in,
    input [9:0] state,
    output reg [9:0] next_state,
    output out1,
    output out2
);

// Output logic - active only in S7-S9
assign out1 = state[8] | state[9];  // S8 or S9
assign out2 = state[7] | state[9];  // S7 or S9

// Common signals
wire in_n = ~in;

always @(*) begin
    // Default all bits to 0
    next_state = 10'b0;

    // S0 transitions
    if (state[0]) begin
        next_state[0] = in_n;
        next_state[1] = in;
    end

    // S1-S4 transitions (grouped for efficiency)
    if (state[1]) begin
        next_state[0] = next_state[0] | in_n;
        next_state[2] = in;
    end
    if (state[2]) begin
        next_state[0] = next_state[0] | in_n;
        next_state[3] = in;
    end
    if (state[3]) begin
        next_state[0] = next_state[0] | in_n;
        next_state[4] = in;
    end
    if (state[4]) begin
        next_state[0] = next_state[0] | in_n;
        next_state[5] = in;
    end

    // S5 transitions
    if (state[5]) begin
        next_state[8] = in_n;
        next_state[6] = in;
    end

    // S6 transitions
    if (state[6]) begin
        next_state[9] = in_n;
        next_state[7] = in;
    end

    // S7 transitions (with self-loop)
    if (state[7]) begin
        next_state[0] = next_state[0] | in_n;
        next_state[7] = in;
    end

    // S8-S9 transitions (grouped for efficiency)
    if (state[8] | state[9]) begin
        next_state[0] = next_state[0] | in_n;
        next_state[1] = next_state[1] | in;
    end
end

endmodule