module TopModule(
    input clk,
    input reset,
    input [7:0] in,
    output done
);

// Enum for states
enum logic [1:0] {IDLE, BYTE1, BYTE2, DONE} state, nextState;

// Default done to 0
assign done = (state == DONE);

always_comb begin
    // Default nextState to current state
    nextState = state;

    case (state)
        IDLE: begin
            // If in[3] is 1, move to BYTE1
            if (in[3]) begin
                nextState = BYTE1;
            end
        end
        BYTE1: begin
            // Move to BYTE2
            nextState = BYTE2;
        end
        BYTE2: begin
            // Move to DONE
            nextState = DONE;
        end
        DONE: begin
            // Move back to IDLE and wait for next message
            nextState = IDLE;
        end
        default: begin
            nextState = IDLE;
        end
    endcase
end

always_ff @(posedge clk) begin
    if (reset) begin
        // Reset FSM to IDLE state
        state <= IDLE;
    end else begin
        // Update state
        state <= nextState;
    end
end

endmodule