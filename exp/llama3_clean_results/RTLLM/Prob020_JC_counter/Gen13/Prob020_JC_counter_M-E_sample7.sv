// Define the module for the 64-bit Johnson counter using a state machine approach
module JC_counter_state_machine(
    input clk,      // Clock signal
    input rst_n,    // Active-low reset signal
    output reg [63:0] Q  // 64-bit register representing the current count value
);

// Define the states of the Johnson counter
reg [5:0] current_state;  // 6-bit register to represent the current state (up to 64 states)
reg [63:0] next_state_value;  // 64-bit register to store the next state's value

// Always block for sequential logic
always @(posedge clk or negedge rst_n) begin
    // Reset condition: Set current_state to 0 and Q to 0 when rst_n is low
    if (~rst_n) begin
        current_state <= 6'd0;
        Q <= 64'd0;
    end else begin
        // Update current_state and Q based on the next expected state
        case (current_state)
            6'd0: begin
                Q <= 64'd1;  // Initial state
                current_state <= 6'd1;
            end
            6'd1: begin
                Q <= {1'b1, Q[63:1]};  // Shift right and append 1
                current_state <= current_state + 1;
            end
            6'd2: begin
                Q <= {1'b1, Q[63:1]};  // Shift right and append 1
                current_state <= current_state + 1;
            end
            //... repeat for all 64 states...
            6'd63: begin
                Q <= {1'b0, Q[63:1]};  // Shift right and append 0 for the last state
                current_state <= 6'd0;  // Wrap around to the initial state
            end
            default: begin
                // Handle any unexpected states
                Q <= 64'd0;
                current_state <= 6'd0;
            end
        endcase
    end
end

endmodule