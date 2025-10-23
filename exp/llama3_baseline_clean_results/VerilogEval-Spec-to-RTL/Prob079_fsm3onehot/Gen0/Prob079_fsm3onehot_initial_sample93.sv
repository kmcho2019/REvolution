module TopModule(
    input in,
    input [3:0] state,
    output [3:0] next_state,
    output out
);

    // Next state logic based on current state and input
    always @(state, in) begin
        case(state)
            4'b0001: // State A
                if (!in) next_state = 4'b0001; // Next state is A when in = 0
                else    next_state = 4'b0010; // Next state is B when in = 1
            4'b0010: // State B
                if (!in) next_state = 4'b0100; // Next state is C when in = 0
                else    next_state = 4'b0010; // Next state is B when in = 1
            4'b0100: // State C
                if (!in) next_state = 4'b0001; // Next state is A when in = 0
                else    next_state = 4'b1000; // Next state is D when in = 1
            4'b1000: // State D
                if (!in) next_state = 4'b0100; // Next state is C when in = 0
                else    next_state = 4'b0010; // Next state is B when in = 1
            default: next_state = 4'b0001; // Default next state if current state is not recognized
        endcase
    end

    // Output logic based on current state
    always @(state) begin
        case(state)
            4'b0001, 4'b0010, 4'b0100: out = 1'b0; // Output is 0 in states A, B, and C
            4'b1000: out = 1'b1; // Output is 1 in state D
            default: out = 1'b0; // Default output if current state is not recognized
        endcase
    end

endmodule