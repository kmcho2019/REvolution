module TopModule (
    input clk,
    input reset,
    input data,
    input done_counting,
    input ack,
    output reg shift_ena,
    output reg counting,
    output reg done
);

// Define states as one-hot encoded constants
parameter IDLE = 4'b0001;
parameter PATTERN_DETECT = 4'b0010;
parameter SHIFT = 4'b0100;
parameter COUNT = 4'b1000;
parameter DONE_ACK = 4'b0001; // Redefine to avoid overlap with other states
// Corrected DONE_ACK definition to avoid conflicts
parameter DONE_ACK_STATE = 4'b1001;

reg [3:0] state; // Current state of the state machine
reg [3:0] pattern; // Pattern register
reg [1:0] shift_cnt; // Shift counter

// Initialize state machine
always @(posedge clk) begin
    if (reset) begin
        // Reset all signals and registers
        state <= IDLE;
        pattern <= 0;
        shift_cnt <= 0;
        shift_ena <= 0;
        counting <= 0;
        done <= 0;
    end
    else begin
        case (state)
            IDLE: begin
                // Update pattern register
                pattern <= {pattern[2:0], data};
                
                // Check for pattern match
                if (pattern == 4'b1101) begin
                    // Transition to PATTERN_DETECT state
                    state <= PATTERN_DETECT;
                end
            end
            PATTERN_DETECT: begin
                // Transition to SHIFT state
                state <= SHIFT;
                shift_cnt <= 0;
                shift_ena <= 1;
            end
            SHIFT: begin
                // Increment shift counter
                shift_cnt <= shift_cnt + 1;
                
                // Check if shift counter has reached 4
                if (shift_cnt < 4) begin
                    // Keep shift enable asserted
                end
                else begin
                    // Deassert shift enable and transition to COUNT state
                    shift_ena <= 0;
                    state <= COUNT;
                    counting <= 1;
                end
            end
            COUNT: begin
                // Wait for done_counting signal
                if (done_counting) begin
                    // Transition to DONE_ACK state
                    state <= DONE_ACK_STATE;
                    counting <= 0;
                    done <= 1;
                end
            end
            DONE_ACK_STATE: begin // Use DONE_ACK_STATE for clarity
                // Wait for acknowledgment
                if (ack) begin
                    // Transition back to IDLE state
                    state <= IDLE;
                    done <= 0;
                end
            end
            default: ; // Prevent latch inference
        endcase
    end
end

endmodule