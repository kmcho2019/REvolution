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
wire any_S1_S4 = |state[4:1];  // Combined detection for S1-S4

always @(*) begin
    // Default all bits to 0
    next_state = 10'b0;

    // Handle S8-S9 first (they have priority in transitions)
    if (state[8] | state[9]) begin
        next_state[0] = in_n;
        next_state[1] = in;
    end
    // Handle S5-S7 (unique states)
    else if (state[5]) begin
        next_state[8] = in_n;
        next_state[6] = in;
    end
    else if (state[6]) begin
        next_state[9] = in_n;
        next_state[7] = in;
    end
    else if (state[7]) begin
        next_state[0] = in_n;
        next_state[7] = in;
    end
    // Handle S0 and S1-S4
    else if (state[0]) begin
        next_state[0] = in_n;
        next_state[1] = in;
    end
    else if (any_S1_S4) begin
        next_state[0] = in_n;
        // Set next state based on current state + 1
        case (1'b1)
            state[1]: next_state[2] = in;
            state[2]: next_state[3] = in;
            state[3]: next_state[4] = in;
            state[4]: next_state[5] = in;
        endcase
    end
end

endmodule