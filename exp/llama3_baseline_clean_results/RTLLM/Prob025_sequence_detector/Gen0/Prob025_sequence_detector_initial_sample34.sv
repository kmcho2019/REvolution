```thought
To implement the sequence detector, we will design a finite state machine (FSM) with five states: IDLE, S1, S2, S3, and S4. The FSM will transition between these states based on the input data_in. In the IDLE state, the detector waits for the first bit of the sequence (1). If the bit matches, it transitions to S1. In S1, it waits for the second bit (0), and so on, until the complete sequence 1001 is detected in S4, at which point the sequence_detected output is set high. The reset_n signal is used to reset the FSM to the IDLE state when it's high.
```

```verilog
module sequence_detector(
    input clk,
    input reset_n,
    input data_in,
    output sequence_detected
);

// Define the states
typedef enum logic [2:0] {
    IDLE,
    S1,
    S2,
    S3,
    S4
} state_t;

state_t current_state;

// Initialize the state to IDLE
initial begin
    current_state = IDLE;
end

// Main logic of the sequence detector
always @(posedge clk or negedge reset_n) begin
    if (!reset_n) begin
        // Reset the state machine
        current_state <= IDLE;
        sequence_detected <= 0;
    end else begin
        case (current_state)
            IDLE: begin
                if (data_in == 1'b1) begin
                    // Transition to S1
                    current_state <= S1;
                end else begin
                    // Stay in IDLE
                    current_state <= IDLE;
                end
            end
            S1: begin
                if (data_in == 1'b0) begin
                    // Transition to S2
                    current_state <= S2;
                end else begin
                    // Restart from IDLE if the sequence does not match
                    current_state <= IDLE;
                end
            end
            S2: begin
                if (data_in == 1'b0) begin
                    // Transition to S3
                    current_state <= S3;
                end else begin
                    // Restart from IDLE if the sequence does not match
                    current_state <= IDLE;
                end
            end
            S3: begin
                if (data_in == 1'b1) begin
                    // Transition to S4
                    current_state <= S4;
                end else begin
                    // Restart from IDLE if the sequence does not match
                    current_state <= IDLE;
                end
            end
            S4: begin
                sequence_detected <= 1'b1;
                // Reset the state machine after detecting the sequence
                current_state <= IDLE;
            end
        endcase
    end
end

// To ensure sequence_detected remains asserted for only one clock cycle after detection
always @(posedge clk) begin
    if (current_state != S4) begin
        sequence_detected <= 1'b0;
    end
end

endmodule
```

--- WARNING: Parsing Issues ---
Could not parse 'code' from LLM response. Expected ```code ... ``` block.(PARSE_ERROR)
