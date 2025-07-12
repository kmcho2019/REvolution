module TopModule (
    input in,
    input [9:0] state,
    output reg [9:0] next_state,
    output out1,
    output out2
);

// Common signals
wire in_n = ~in;
wire any_S1_S4 = |state[4:1];  // States S1-S4
wire any_S8_S9 = |state[9:8];  // States S8-S9

// Output logic
assign out1 = any_S8_S9;       // S8 or S9
assign out2 = state[7] | state[9]; // S7 or S9

always @(*) begin
    // Default all bits to 0
    next_state = 10'b0;

    // S0 transitions
    if (state[0]) begin
        next_state[0] = in_n;
        next_state[1] = in;
    end

    // S1-S4 transitions (grouped for efficiency)
    if (any_S1_S4) begin
        next_state[0] = in_n;
        case (1'b1)
            state[1]: next_state[2] = in;
            state[2]: next_state[3] = in;
            state[3]: next_state[4] = in;
            state[4]: next_state[5] = in;
        endcase
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
        next_state[0] = in_n;
        next_state[7] = in;
    end

    // S8-S9 transitions (grouped for efficiency)
    if (any_S8_S9) begin
        next_state[0] = in_n;
        next_state[1] = in;
    end
end

endmodule