```thought
To implement the sequence detector, we'll use a finite state machine (FSM) with five states: IDLE, S1, S2, S3, and S4. The FSM will transition through these states based on the input data_in. When the sequence 1001 is detected, the output sequence_detected will be set high. We'll use a clock signal clk to synchronize the detector and a reset signal reset_n to initialize the state machine. The internal logic will be designed to handle the transitions between states and detect the specific sequence.
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
    IDLE,
    S1,
    S2,
    S3,
    S4
} state_t;

// Initialize the current state and next state
state_t current_state, next_state;

// Assign the output sequence_detected based on the current state
assign sequence_detected = (current_state == S4);

// Define the FSM transitions
always_comb begin
    case (current_state)
        IDLE: begin
            if (data_in == 1'b1) begin
                next_state = S1;
            end else begin
                next_state = IDLE;
            end
        end
        S1: begin
            if (data_in == 1'b0) begin
                next_state = S2;
            end else begin
                next_state = S1;
            end
        end
        S2: begin
            if (data_in == 1'b0) begin
                next_state = S2;
            end else begin
                next_state = S3;
            end
        end
        S3: begin
            if (data_in == 1'b1) begin
                next_state = S4;
            end else begin
                next_state = IDLE;
            end
        end
        S4: begin
            next_state = IDLE;
        end
        default: begin
            next_state = IDLE;
        end
    endcase
end

// Update the current state on each clock cycle
always_ff @(posedge clk or negedge reset_n) begin
    if (~reset_n) begin
        current_state <= IDLE;
    end else begin
        current_state <= next_state;
    end
end

endmodule
```

Note: The code provided is in Verilog-2001 syntax and uses a systematic approach to design the sequence detector. The module is fully synthesizable and can be used in a digital design flow.

--- WARNING: Parsing Issues ---
Could not parse 'code' from LLM response. Expected ```code ... ``` block.(PARSE_ERROR)
