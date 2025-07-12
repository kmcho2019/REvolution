module TopModule(
    input clk,
    input reset,
    input in,
    output reg out
);

// Define the states as parameters
parameter STATE_B = 1'b1;
parameter STATE_A = 1'b0;

// Current state register
reg state;

// Next state register
reg next_state;

// Output register
reg output;

// Determine the next state based on the current state and input
always @(state, in) begin
    case (state)
        STATE_B: begin
            if (~in) begin
                next_state = STATE_A;
            end else begin
                next_state = STATE_B;
            end
        end
        STATE_A: begin
            if (~in) begin
                next_state = STATE_B;
            end else begin
                next_state = STATE_A;
            end
        end
        default: begin
            next_state = STATE_B; // Default to state B
        end
    endcase
end

// Update the current state and output based on the next state
always @(posedge clk) begin
    if (reset) begin
        state <= STATE_B; // Reset to state B
        output <= 1'b1; // Output for state B
    end else begin
        state <= next_state;
        case (next_state)
            STATE_B: output <= 1'b1;
            STATE_A: output <= 1'b0;
            default: output <= 1'b1; // Default to output for state B
        endcase
    end
end

assign out = output;

endmodule