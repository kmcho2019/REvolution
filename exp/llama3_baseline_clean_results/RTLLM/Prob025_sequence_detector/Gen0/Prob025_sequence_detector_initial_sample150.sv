```thought
To design a sequence detector for the specific 4-bit binary sequence 1001, we'll implement a finite state machine (FSM) with five states: IDLE, S1, S2, S3, and S4. The detector starts in the IDLE state, waiting for the sequence to begin. On each clock cycle, it checks the input data_in and transitions to the next state if the bit matches the expected sequence. If the entire sequence is detected (i.e., it reaches state S4), the output sequence_detected is asserted. The reset_n signal is used to return the FSM to the IDLE state when it is high.
```

```verilog
module sequence_detector(
    input clk,  // Clock signal
    input reset_n,  // Reset signal
    input data_in,  // 1-bit binary input signal
    output reg sequence_detected  // 1-bit output signal
);

// Define states
enum logic [2:0] {
    IDLE = 3'b000,
    S1 = 3'b001,
    S2 = 3'b010,
    S3 = 3'b011,
    S4 = 3'b100
} state, next_state;

// State machine
always @(*) begin
    case (state)
        IDLE: begin
            if (data_in == 1'b1) begin  // First bit of the sequence
                next_state = S1;
            end else begin
                next_state = IDLE;
            end
        end
        S1: begin
            if (data_in == 1'b0) begin  // Second bit of the sequence
                next_state = S2;
            end else begin
                next_state = IDLE;  // Reset to IDLE if sequence is broken
            end
        end
        S2: begin
            if (data_in == 1'b0) begin  // Third bit of the sequence
                next_state = S3;
            end else begin
                next_state = IDLE;  // Reset to IDLE if sequence is broken
            end
        end
        S3: begin
            if (data_in == 1'b1) begin  // Fourth bit of the sequence
                next_state = S4;
            end else begin
                next_state = IDLE;  // Reset to IDLE if sequence is broken
            end
        end
        S4: begin
            sequence_detected = 1'b1;
            next_state = IDLE;  // After detecting the sequence, return to IDLE
        end
    endcase
end

// Update state on clock edge
always @(posedge clk or negedge reset_n) begin
    if (~reset_n) begin
        state <= IDLE;
        sequence_detected <= 1'b0;
    end else begin
        state <= next_state;
    end
end

endmodule
```

--- WARNING: Parsing Issues ---
Could not parse 'code' from LLM response. Expected ```code ... ``` block.(PARSE_ERROR)
