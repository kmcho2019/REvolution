```thought
To implement the sequence detector module, we will design a finite state machine (FSM) with the specified states: IDLE, S1, S2, S3, and S4. The FSM will transition between states based on the input data_in and the current state. The sequence_detected output will be asserted when the FSM reaches the S4 state. The module will also include a reset functionality to return the FSM to the IDLE state when reset_n is low.
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
    S1   = 3'b001,
    S2   = 3'b010,
    S3   = 3'b011,
    S4   = 3'b100
} state_t;

// Declare the current and next states
state_t current_state, next_state;

// Assign the output sequence_detected based on the current state
assign sequence_detected = (current_state == S4);

// FSM logic
always_comb begin
    case(current_state)
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
