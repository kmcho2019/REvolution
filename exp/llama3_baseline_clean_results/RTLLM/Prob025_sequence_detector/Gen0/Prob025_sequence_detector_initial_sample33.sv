```thought
To implement the sequence detector module, I will design a finite state machine (FSM) with five states: IDLE, S1, S2, S3, and S4. The FSM will transition between these states based on the input bitstream data_in. On each clock cycle, the detector will check for a match of the specific sequence 1001. When the complete sequence is detected, the sequence_detected output will be asserted high. The FSM will also be reset to the IDLE state when the reset_n signal is low.
```

```verilog
module sequence_detector(
    input clk, 
    input reset_n, 
    input data_in, 
    output sequence_detected
);

// Enumerated states
enum logic [2:0] {
    IDLE = 3'b000,
    S1 = 3'b001,
    S2 = 3'b010,
    S3 = 3'b011,
    S4 = 3'b100
} state, next_state;

// State machine logic
always_comb begin
    case (state)
        IDLE: begin
            if (data_in == 1'b1) next_state = S1;
            else next_state = IDLE;
        end
        S1: begin
            if (data_in == 1'b0) next_state = S2;
            else next_state = IDLE;
        end
        S2: begin
            if (data_in == 1'b0) next_state = S2;
            else next_state = S3;
        end
        S3: begin
            if (data_in == 1'b1) next_state = S4;
            else next_state = IDLE;
        end
        S4: begin
            next_state = IDLE; // reset state after detection
        end
        default: next_state = IDLE;
    endcase
end

// State register
always_ff @(posedge clk or negedge reset_n) begin
    if (!reset_n) begin
        state <= IDLE;
        sequence_detected <= 1'b0;
    end else begin
        state <= next_state;
        if (next_state == S4) sequence_detected <= 1'b1;
        else sequence_detected <= 1'b0;
    end
end

endmodule
```

--- WARNING: Parsing Issues ---
Could not parse 'code' from LLM response. Expected ```code ... ``` block.(PARSE_ERROR)
