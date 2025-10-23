module TopModule (
    input in,
    input [3:0] state,
    output reg [3:0] next_state,
    output out
);

    // Next state logic - optimized fused implementation
    always @(*) begin
        next_state = 4'b0000; // Clear all bits first
        
        case (1'b1) // synthesis parallel_case
            state[0]: begin // State A (0001)
                next_state[0] = ~in;
                next_state[1] = in;
            end
            state[1]: begin // State B (0010)
                next_state[1] = in;
                next_state[2] = ~in;
            end
            state[2]: begin // State C (0100)
                next_state[0] = ~in;
                next_state[3] = in;
            end
            state[3]: begin // State D (1000)
                next_state[1] = in;
                next_state[2] = ~in;
            end
        endcase
    end

    // Output logic (Moore: output depends only on current state)
    assign out = state[3]; // Output is 1 only in state D

endmodule