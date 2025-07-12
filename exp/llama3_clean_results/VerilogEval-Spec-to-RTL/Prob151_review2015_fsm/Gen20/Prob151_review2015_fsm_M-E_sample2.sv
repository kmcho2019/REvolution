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
parameter IDLE = 2'b00;
parameter PATTERN_MATCH = 2'b01;

parameter SHIFT = 2'b00;
parameter COUNT = 2'b01;
parameter DONE_WAIT = 2'b10;
parameter ACK_WAIT = 2'b11;

reg [1:0] pattern_state; // Current state of the pattern detector
reg [1:0] timer_state; // Current state of the timer controller
reg [3:0] pattern; // Pattern register
reg [1:0] shift_cnt; // Shift counter

// Initialize state machines
always @(posedge clk) begin
    if (reset) begin
        // Reset all signals and registers
        pattern_state <= IDLE;
        timer_state <= SHIFT;
        pattern <= 0;
        shift_cnt <= 0;
        shift_ena <= 0;
        counting <= 0;
        done <= 0;
    end
    else begin
        case (pattern_state)
            IDLE: begin
                // Update pattern register
                pattern <= {pattern[2:0], data};
                
                // Check for pattern match
                if (pattern == 4'b1101) begin
                    // Transition to PATTERN_MATCH state
                    pattern_state <= PATTERN_MATCH;
                end
            end
            PATTERN_MATCH: begin
                // Reset pattern register and transition to IDLE state
                pattern <= 0;
                pattern_state <= IDLE;
                
                // Start timer controller
                timer_state <= SHIFT;
                shift_ena <= 1;
            end
        endcase
        
        case (timer_state)
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
                    timer_state <= COUNT;
                    counting <= 1;
                end
            end
            COUNT: begin
                // Wait for done_counting signal
                if (done_counting) begin
                    // Transition to DONE_WAIT state
                    timer_state <= DONE_WAIT;
                    counting <= 0;
                    done <= 1;
                end
            end
            DONE_WAIT: begin
                // Wait for ack signal
                if (ack) begin
                    // Transition to ACK_WAIT state
                    timer_state <= ACK_WAIT;
                end
            end
            ACK_WAIT: begin
                // Reset done signal and transition to SHIFT state
                done <= 0;
                timer_state <= SHIFT;
            end
        endcase
    end
end

endmodule