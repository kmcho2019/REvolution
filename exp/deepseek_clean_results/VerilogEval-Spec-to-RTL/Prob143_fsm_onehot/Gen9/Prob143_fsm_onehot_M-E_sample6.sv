module TopModule (
    input in,
    input [9:0] state,
    output reg [9:0] next_state,
    output out1,
    output out2
);

// State groups
wire group0 = |state[4:0];  // S0-S4
wire group1 = |state[6:5];  // S5-S6
wire group2 = state[7];     // S7
wire group3 = |state[9:8];  // S8-S9

// Common transition signals
wire to_S0 = ~in;
wire to_S1 = in;
wire to_S7 = in & state[7];

// Output logic (direct from state bits)
assign out1 = state[8] | state[9];
assign out2 = state[7] | state[9];

always @(*) begin
    next_state = 10'b0;
    
    // Group 0: S0-S4 transitions
    if (group0) begin
        next_state[0] = to_S0;
        case (1'b1)
            state[0]: next_state[1] = to_S1;
            state[1]: next_state[2] = to_S1;
            state[2]: next_state[3] = to_S1;
            state[3]: next_state[4] = to_S1;
            state[4]: next_state[5] = to_S1;
        endcase
    end
    
    // Group 1: S5-S6 transitions
    if (group1) begin
        case (1'b1)
            state[5]: begin
                next_state[8] = to_S0;
                next_state[6] = to_S1;
            end
            state[6]: begin
                next_state[9] = to_S0;
                next_state[7] = to_S1;
            end
        endcase
    end
    
    // Group 2: S7 transitions
    if (group2) begin
        next_state[0] = next_state[0] | to_S0;
        next_state[7] = to_S7;
    end
    
    // Group 3: S8-S9 transitions
    if (group3) begin
        next_state[0] = next_state[0] | to_S0;
        next_state[1] = next_state[1] | to_S1;
    end
end

endmodule