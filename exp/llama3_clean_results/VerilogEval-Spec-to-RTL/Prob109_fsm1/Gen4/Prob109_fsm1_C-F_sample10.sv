module TopModule(
    input  clk,
    input  areset,
    input  in,
    output out
);

reg state; // 1-bit signal to keep track of the current state
reg next_state; // 1-bit signal to determine the next state

always @(posedge clk or posedge areset) begin
    if (areset) begin // Asynchronous reset
        state <= 1'b1; // Reset to state B
    end else begin
        // Determine the next state based on the current state and input
        case (state)
            1'b0: // State A
                case (in)
                    1'b0: next_state = 1'b1; // A (0) --0--> B
                    1'b1: next_state = 1'b0; // A (0) --1--> A
                    default: next_state = 1'b0;
                endcase
            1'b1: // State B
                case (in)
                    1'b0: next_state = 1'b0; // B (1) --0--> A
                    1'b1: next_state = 1'b1; // B (1) --1--> B
                    default: next_state = 1'b1;
                endcase
            default: next_state = 1'b1;
        endcase
        // Update the current state
        state <= next_state;
    end
end

// Out is derived directly from the state in a Moore machine
assign out = state;

endmodule