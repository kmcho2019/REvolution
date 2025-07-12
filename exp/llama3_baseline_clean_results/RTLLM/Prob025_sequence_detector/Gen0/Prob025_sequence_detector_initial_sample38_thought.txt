```thought
The sequence detector will be implemented as a finite state machine (FSM) with four states: IDLE, S1, S2, S3, and S4. The FSM will transition through these states based on the input bitstream data_in. In the IDLE state, the FSM will wait for the first bit of the sequence (1) to arrive. Once the first bit is detected, the FSM will transition to the S1 state. In the S1 state, the FSM will wait for the second bit of the sequence (0) to arrive. Once the second bit is detected, the FSM will transition to the S2 state. In the S2 state, the FSM will wait for the third bit of the sequence (0) to arrive. Once the third bit is detected, the FSM will transition to the S3 state. In the S3 state, the FSM will wait for the fourth and final bit of the sequence (1) to arrive. Once the fourth bit is detected, the FSM will transition to the S4 state and assert the sequence_detected signal. On reset, the FSM will return to the IDLE state.
```

```verilog
module sequence_detector (
    input clk,
    input reset_n,
    input data_in,
    output reg sequence_detected
);

// Define the states
enum logic [2:0] {
    IDLE = 3'b001,
    S1 = 3'b010,
    S2 = 3'b011,
    S3 = 3'b100,
    S4 = 3'b101
} state, next_state;

// State register
always @(posedge clk or negedge reset_n) begin
    if (!reset_n) begin
        state <= IDLE;
        sequence_detected <= 1'b0;
    end else begin
        state <= next_state;
        if (state == S4) begin
            sequence_detected <= 1'b1;
        end else begin
            sequence_detected <= 1'b0;
        end
    end
end

// Next state logic
always @(*) begin
    case (state)
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
        end
        default: begin
            next_state = IDLE;
        end
    endcase
end

endmodule
```

--- WARNING: Parsing Issues ---
Could not parse 'code' from LLM response. Expected ```code ... ``` block.(PARSE_ERROR)
