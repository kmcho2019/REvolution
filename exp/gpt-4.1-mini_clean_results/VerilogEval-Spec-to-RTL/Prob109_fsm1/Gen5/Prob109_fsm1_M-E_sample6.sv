module TopModule (
    input  clk,
    input  areset,
    input  in,
    output out
);

    // One-hot state encoding: state_A = 2'b01, state_B = 2'b10
    reg [1:0] state, next_state;

    // Combinational logic to determine next state
    always @(*) begin
        case (state)
            2'b10: // State B (output=1)
                if (in == 1'b0)
                    next_state = 2'b01; // Transition to A
                else
                    next_state = 2'b10; // Stay in B
            2'b01: // State A (output=0)
                if (in == 1'b0)
                    next_state = 2'b10; // Transition to B
                else
                    next_state = 2'b01; // Stay in A
            default:
                next_state = 2'b10; // Default/reset to B
        endcase
    end

    // Sequential logic with asynchronous reset to state B (2'b10)
    always @(posedge clk or posedge areset) begin
        if (areset)
            state <= 2'b10; // Reset to B
        else
            state <= next_state;
    end

    // Output is 1 when in state B (state[1] set), else 0
    assign out = state[1];

endmodule