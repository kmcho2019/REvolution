module TopModule (
    input in,
    input [9:0] state,
    output reg [9:0] next_state,
    output out1,
    output out2
);

// State group definitions
wire group_a = |state[4:0];  // S0-S4
wire group_b = |state[6:5];  // S5-S6
wire group_c = |state[9:7];  // S7-S9

// Group-based transition logic
always @(*) begin
    next_state = 10'b0;
    
    // Group A transitions (S0-S4)
    if (group_a) begin
        case (1'b1)
            state[0]: begin // S0
                next_state[0] = ~in;
                next_state[1] = in;
            end
            state[1]: begin // S1
                next_state[0] = ~in;
                next_state[2] = in;
            end
            state[2]: begin // S2
                next_state[0] = ~in;
                next_state[3] = in;
            end
            state[3]: begin // S3
                next_state[0] = ~in;
                next_state[4] = in;
            end
            state[4]: begin // S4
                next_state[0] = ~in;
                next_state[5] = in;
            end
        endcase
    end
    
    // Group B transitions (S5-S6)
    if (group_b) begin
        case (1'b1)
            state[5]: begin // S5
                next_state[8] = ~in;
                next_state[6] = in;
            end
            state[6]: begin // S6
                next_state[9] = ~in;
                next_state[7] = in;
            end
        endcase
    end
    
    // Group C transitions (S7-S9)
    if (group_c) begin
        case (1'b1)
            state[7]: begin // S7
                next_state[0] = ~in;
                next_state[7] = in;
            end
            state[8]: begin // S8
                next_state[0] = ~in;
                next_state[1] = in;
            end
            state[9]: begin // S9
                next_state[0] = ~in;
                next_state[1] = in;
            end
        endcase
    end
end

// Hierarchical output calculation
// Group C has highest priority, then B, then A
wire out1_c = state[8] | state[9];
wire out1_b = 1'b0;
wire out1_a = 1'b0;

wire out2_c = state[7] | state[9];
wire out2_b = 1'b0;
wire out2_a = 1'b0;

assign out1 = out1_c | out1_b | out1_a;
assign out2 = out2_c | out2_b | out2_a;

endmodule