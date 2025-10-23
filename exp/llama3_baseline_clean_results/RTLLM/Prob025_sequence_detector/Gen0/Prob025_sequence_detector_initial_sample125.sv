```thought
To implement the sequence detector, we will design a finite state machine (FSM) with five states: IDLE, S1, S2, S3, and S4. The FSM will transition between these states based on the input bitstream data_in. On each clock cycle, the detector will check for a match of the specific sequence. When the complete sequence is detected, the output sequence_detected will be asserted. The module will also have a reset mechanism to return to the IDLE state when reset_n is low.
```

```verilog
module sequence_detector(
    input clk,
    input reset_n,
    input data_in,
    output reg sequence_detected
);

// Define the states of the finite state machine
typedef enum logic [2:0] {
    IDLE,
    S1,
    S2,
    S3,
    S4
} state_t;

state_t current_state, next_state;

// FSM transitions
always @(*) begin
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
                next_state = IDLE;
            end
        end
        S2: begin
            if (data_in == 1'b0) begin
                next_state = S3;
            end else begin
                next_state = IDLE;
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
            sequence_detected = 1'b1;
        end
        default: next_state = IDLE;
    endcase
end

// Update the current state on each clock cycle
always @(posedge clk or negedge reset_n) begin
    if (!reset_n) begin
        current_state <= IDLE;
        sequence_detected <= 1'b0;
    end else begin
        current_state <= next_state;
        if (current_state == S4) begin
            sequence_detected <= 1'b1;
        end else begin
            sequence_detected <= 1'b0;
        end
    end
end

endmodule
```

--- WARNING: Parsing Issues ---
Could not parse 'code' from LLM response. Expected ```code ... ``` block.(PARSE_ERROR)
