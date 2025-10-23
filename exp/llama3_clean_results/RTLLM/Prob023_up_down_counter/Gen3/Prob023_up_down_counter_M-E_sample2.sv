module up_down_counter(
    input clk,         // Clock signal
    input reset,       // Reset signal
    input up_down,     // Control signal for counting direction
    output reg [15:0] count  // 16-bit output representing the current counter value
);

// Enumerate the states of the finite state machine
enum logic [1:0] {IDLE, COUNTING} state, next_state;

// Synchronous process for the finite state machine
always @ (posedge clk) begin
    if (reset) begin
        // Reset the counter to zero when the reset signal is active
        state <= IDLE;
        count <= 16'd0;
    end else begin
        state <= next_state;
        case (state)
            IDLE: begin
                // Transition to the counting state when not in reset
                next_state <= COUNTING;
            end
            COUNTING: begin
                // Stay in the counting state
                next_state <= COUNTING;
                if (up_down) begin
                    // Increment the counter when up_down is high
                    count <= count + 1;
                end else begin
                    // Decrement the counter when up_down is low
                    count <= count - 1;
                end
            end
            default: begin
                // Default case to prevent latches
                next_state <= IDLE;
            end
        endcase
    end
end

endmodule