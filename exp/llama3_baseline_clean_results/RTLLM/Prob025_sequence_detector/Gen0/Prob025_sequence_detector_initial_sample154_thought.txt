```thought
The sequence detector can be implemented using a finite state machine (FSM) with five states: IDLE, S1, S2, S3, and S4. The FSM transitions between states based on the input bitstream data_in. On each clock cycle, the detector checks for a match of the specific sequence 1001. When the complete sequence is detected, the output sequence_detected is asserted. The reset signal reset_n is used to reset the state machine to the IDLE state when it is low.
```

```verilog
module sequence_detector(
    input clk,
    input reset_n,
    input data_in,
    output sequence_detected
);

// Define the states of the FSM
typedef enum logic [2:0] {
    IDLE = 3'b000,
    S1 = 3'b001,
    S2 = 3'b010,
    S3 = 3'b011,
    S4 = 3'b100
} state_t;

// Declare the current state and next state variables
state_t current_state, next_state;

// Assign the output sequence_detected to 0 by default
assign sequence_detected = (current_state == S4) ? 1'b1 : 1'b0;

// Describe the sequential logic of the FSM
always_ff @(posedge clk, negedge reset_n) begin
    if (!reset_n) begin
        current_state <= IDLE;
    end else begin
        current_state <= next_state;
    end
end

// Describe the combinational logic of the FSM
always_comb begin
    case (current_state)
        IDLE: begin
            if (data_in == 1'b1) begin
                next_state = IDLE; // Stay in IDLE if data_in is not 0
            end else if (data_in == 1'b0) begin
                next_state = S1; // Transition to S1 if data_in is 0
            end
        end
        S1: begin
            if (data_in == 1'b0) begin
                next_state = S1; // Stay in S1 if data_in is not 1
            end else if (data_in == 1'b1) begin
                next_state = S2; // Transition to S2 if data_in is 1
            end
        end
        S2: begin
            if (data_in == 1'b0) begin
                next_state = S3; // Transition to S3 if data_in is 0
            end else if (data_in == 1'b1) begin
                next_state = S1; // Transition back to S1 if data_in is 1
            end
        end
        S3: begin
            if (data_in == 1'b1) begin
                next_state = S4; // Transition to S4 if data_in is 1
            end else if (data_in == 1'b0) begin
                next_state = IDLE; // Transition back to IDLE if data_in is 0
            end
        end
        S4: begin
            next_state = IDLE; // Transition back to IDLE after sequence detection
        end
        default: next_state = IDLE;
    endcase
end

endmodule
```

--- WARNING: Parsing Issues ---
Could not parse 'code' from LLM response. Expected ```code ... ``` block.(PARSE_ERROR)
