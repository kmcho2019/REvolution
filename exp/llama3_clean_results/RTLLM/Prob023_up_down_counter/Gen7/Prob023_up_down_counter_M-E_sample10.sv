module up_down_counter (
    input clk,         // Clock signal
    input reset,       // Reset signal
    input up_down,     // Control signal for counting direction
    output reg [15:0] count  // 16-bit output representing the current counter value
);

// Enum for states
enum logic [1:0] {RESET, IDLE, INCREMENT, DECREMENT} state, next_state;

// Default state transition
always_comb begin
    next_state = state;
    case(state)
        RESET: begin
            if (~reset) next_state = IDLE;
        end
        IDLE: begin
            if (up_down) next_state = INCREMENT;
            else if (~up_down) next_state = DECREMENT;
        end
        INCREMENT: begin
            if (~up_down) next_state = IDLE;
            count = count + 1;
        end
        DECREMENT: begin
            if (up_down) next_state = IDLE;
            count = count - 1;
        end
        default: next_state = IDLE;
    endcase
end

// Sequential logic for state update and reset handling
always_ff @ (posedge clk) begin
    if (reset) begin
        state <= RESET;
        count <= 16'd0;
    end else begin
        state <= next_state;
    end
end

endmodule