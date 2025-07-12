```thought
The sequence detector can be implemented using a finite state machine (FSM) that transitions through five states: IDLE, S1, S2, S3, and S4. The FSM starts in the IDLE state and transitions to subsequent states based on the input bitstream. The detector checks for a match of the specific sequence '1001' and asserts the output sequence_detected when the sequence is detected. The reset signal reset_n is used to initialize the state machine to the IDLE state. The state machine's next state is determined by the current state and the input data_in. The output sequence_detected is asserted when the state machine reaches the S4 state.
```
```verilog
module sequence_detector(
    input clk,
    input reset_n,
    input data_in,
    output sequence_detected
);

// Define the states of the finite state machine
typedef enum logic [2:0] {
    IDLE = 3'b000,
    S1 = 3'b001,
    S2 = 3'b010,
    S3 = 3'b011,
    S4 = 3'b100
} state_t;

// Declare the current and next states
state_t current_state, next_state;

// Initialize the output sequence_detected to 0
assign sequence_detected = (current_state == S4) ? 1'b1 : 1'b0;

// State machine logic
always_comb begin
    case (current_state)
        IDLE: begin
            if (data_in == 1'b1)
                next_state = S1;
            else
                next_state = IDLE;
        end
        S1: begin
            if (data_in == 1'b0)
                next_state = S2;
            else
                next_state = S1;
        end
        S2: begin
            if (data_in == 1'b0)
                next_state = S2;
            else
                next_state = S3;
        end
        S3: begin
            if (data_in == 1'b1)
                next_state = S4;
            else
                next_state = IDLE;
        end
        S4: begin
            next_state = IDLE;
        end
        default: next_state = IDLE;
    endcase
end

// Sequential logic to update the current state
always_ff @(posedge clk or negedge reset_n) begin
    if (~reset_n)
        current_state <= IDLE;
    else
        current_state <= next_state;
end

endmodule
```

--- WARNING: Parsing Issues ---
Could not parse 'code' from LLM response. Expected ```code ... ``` block.(PARSE_ERROR)
