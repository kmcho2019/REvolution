module TopModule(
    input clk,
    input a,
    output reg [2:0] q
);

// Define states for the FSM
typedef enum logic [2:0] {
    S_RESET = 3'b100,  // Initial state (q = 4)
    S_INCREMENT,      // State for incrementing q
    S_WRAP_AROUND     // State for wrapping q around from 6 to 0
} state_t;

state_t current_state, next_state;

always @(posedge clk) begin
    current_state <= next_state;
end

always @(*) begin
    case (current_state)
        S_RESET: begin
            if (a) begin
                next_state <= S_RESET;  // Stay in reset state if a is high
            end else begin
                next_state <= S_INCREMENT;  // Move to increment state if a is low
            end
        end
        S_INCREMENT: begin
            if (q == 6) begin
                next_state <= S_WRAP_AROUND;  // Wrap around when q reaches 6
            end else if (a) begin
                next_state <= S_RESET;  // Reset if a becomes high during increment
            end else begin
                next_state <= S_INCREMENT;  // Continue incrementing if a remains low
            end
        end
        S_WRAP_AROUND: begin
            next_state <= S_INCREMENT;  // Move back to increment state after wrap-around
        end
        default: begin
            next_state <= S_RESET;  // Default to reset state for any other condition
        end
    endcase
end

always @(posedge clk) begin
    case (current_state)
        S_RESET: begin
            q <= 4;  // Reset q to 4
        end
        S_INCREMENT: begin
            q <= q + 1;  // Increment q
        end
        S_WRAP_AROUND: begin
            q <= 0;  // Wrap q around to 0
        end
        default: begin
            // No action for default or other states
        end
    endcase
end

// Initialize the state and output
initial begin
    current_state <= S_RESET;
    q <= 4;
end

endmodule