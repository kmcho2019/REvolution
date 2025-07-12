module TopModule (
    input in,
    input [9:0] state,
    output reg [9:0] next_state,
    output reg out1,
    output reg out2
);

// Group signals
wire group1_active = |state[4:0];      // S0-S4
wire group2_active = |state[6:5];      // S5-S6
wire group3_active = |state[9:7];      // S7-S9

// Group transition logic
wire group1_next = group1_active & ~in;
wire group1_advance = group1_active & in;
wire group2_branch = group2_active & ~in;
wire group2_advance = group2_active & in;
wire group3_reset = group3_active & ~in;
wire group3_hold = group3_active & in;

always @(*) begin
    // Default all outputs to 0
    next_state = 10'b0;
    out1 = 1'b0;
    out2 = 1'b0;

    // Handle group transitions
    if (group1_next) next_state[0] = 1'b1;
    if (group1_advance) begin
        case (1'b1)
            state[0]: next_state[1] = 1'b1;
            state[1]: next_state[2] = 1'b1;
            state[2]: next_state[3] = 1'b1;
            state[3]: next_state[4] = 1'b1;
            state[4]: next_state[5] = 1'b1;
        endcase
    end

    if (group2_branch) begin
        case (1'b1)
            state[5]: next_state[8] = 1'b1;
            state[6]: next_state[9] = 1'b1;
        endcase
    end
    if (group2_advance) begin
        case (1'b1)
            state[5]: next_state[6] = 1'b1;
            state[6]: next_state[7] = 1'b1;
        endcase
    end

    if (group3_reset) next_state[0] = 1'b1;
    if (group3_hold) begin
        case (1'b1)
            state[7]: next_state[7] = 1'b1;
            state[8], state[9]: next_state[1] = 1'b1;
        endcase
    end

    // Output logic based on group3
    if (group3_active) begin
        out1 = state[8] | state[9];
        out2 = state[7] | state[9];
    end
end

endmodule