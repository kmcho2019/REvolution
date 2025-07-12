module pulse_detect(
    input clk,
    input rst_n,
    input data_in,
    output data_out
);

// Define the states for the pulse detection process
typedef enum logic [1:0] {
    IDLE,
    PULSE_RISING,
    PULSE_FALLING
} state_t;

// Declare the current state and next state registers
state_t current_state, next_state;

// Assign the output data_out
assign data_out = (current_state == PULSE_FALLING)? 1'b1 : 1'b0;

// Implement the state machine
always @(posedge clk, negedge rst_n) begin
    if (~rst_n) begin
        // Reset the state machine
        current_state <= IDLE;
    end else begin
        // Update the current state
        current_state <= next_state;
    end
end

// Implement the next state logic
always @(*) begin
    case (current_state)
        IDLE: begin
            if (data_in) begin
                next_state = PULSE_RISING;
            end else begin
                next_state = IDLE;
            end
        end
        PULSE_RISING: begin
            if (~data_in) begin
                next_state = PULSE_FALLING;
            end else begin
                next_state = PULSE_RISING;
            end
        end
        PULSE_FALLING: begin
            next_state = IDLE;
        end
        default: begin
            next_state = IDLE;
        end
    endcase
end

endmodule