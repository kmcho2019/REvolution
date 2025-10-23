module TopModule (
    input in,
    input [9:0] state,
    output reg [9:0] next_state,
    output out1,
    output out2
);

// Optimized output logic - active only in S7-S9
assign out1 = state[8] | state[9];  // S8 or S9
assign out2 = state[7] | state[9];  // S7 or S9

// Precompute common signals
wire in_n = ~in;

always @(*) begin
    // Initialize all bits to 0
    next_state = 10'b0;

    // Handle S0 transitions (unique pattern)
    if (state[0]) begin
        next_state[0] = in_n;
        next_state[1] = in;
    end

    // Handle S1-S4 transitions (grouped for efficiency)
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

    // Handle S5 transitions (unique pattern)
    if (state[5]) begin
        next_state[8] = in_n;
        next_state[6] = in;
    end

    // Handle S6 transitions (unique pattern)
    if (state[6]) begin
        next_state[9] = in_n;
        next_state[7] = in;
    end

    // Handle S7 transitions (self-loop)
    if (state[7]) begin
        next_state[0] = next_state[0] | in_n;
        next_state[7] = in;
    end

    // Handle S8-S9 transitions (grouped for efficiency)
    if (state[8]) begin
        next_state[0] = next_state[0] | in_n;
        next_state[1] = next_state[1] | in;
    end
    if (state[9]) begin
        next_state[0] = next_state[0] | in_n;
        next_state[1] = next_state[1] | in;
    end
end

endmodule