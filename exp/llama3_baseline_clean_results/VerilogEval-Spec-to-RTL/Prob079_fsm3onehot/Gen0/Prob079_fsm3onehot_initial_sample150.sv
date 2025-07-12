module TopModule(
    input in,
    input [3:0] state,
    output [3:0] next_state,
    output out
);

    // Output logic
    // Output is 1 only when the current state is D
    assign out = state[3]; // Since state D is encoded as 4'b1000

    // State transition logic
    always @(*) begin
        case(state)
            4'b0001: // State A
                if (!in) next_state = 4'b0001; // Next state is A when in=0
                else next_state = 4'b0010; // Next state is B when in=1
            4'b0010: // State B
                if (!in) next_state = 4'b0100; // Next state is C when in=0
                else next_state = 4'b0010; // Next state is B when in=1
            4'b0100: // State C
                if (!in) next_state = 4'b0001; // Next state is A when in=0
                else next_state = 4'b1000; // Next state is D when in=1
            4'b1000: // State D
                if (!in) next_state = 4'b0100; // Next state is C when in=0
                else next_state = 4'b0010; // Next state is B when in=1
            default: next_state = 4'b0000; // Default next state (should not occur with one-hot encoding)
        endcase
    end

endmodule