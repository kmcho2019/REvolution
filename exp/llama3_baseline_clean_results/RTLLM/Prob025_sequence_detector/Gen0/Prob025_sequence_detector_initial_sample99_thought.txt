```thought
To implement the sequence detector module, we will use a finite state machine (FSM) with five states: IDLE, S1, S2, S3, and S4. The FSM will transition between these states based on the input bitstream data_in. On each clock cycle, the detector checks for a match of the specific sequence 1001. When the complete sequence is detected, the output sequence_detected is set high. The module also includes a reset mechanism that returns the state machine to the IDLE state when reset_n is low.
```
```verilog
module sequence_detector(
    input clk,
    input reset_n,
    input data_in,
    output reg sequence_detected
);

// Enumerate the states of the FSM
enum logic [2:0] {
    IDLE = 3'b000,
    S1   = 3'b001,
    S2   = 3'b010,
    S3   = 3'b011,
    S4   = 3'b100
} state, next_state;

// Assign the initial state
initial state = IDLE;

// Sequence detection logic
always @(*) begin
    next_state = state;
    sequence_detected = 1'b0;
    case(state)
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
            sequence_detected = 1'b1;
            next_state = IDLE;
        end
    endcase
end

// Update the state on each clock cycle
always @(posedge clk or negedge reset_n) begin
    if (~reset_n) begin
        state <= IDLE;
    end else begin
        state <= next_state;
    end
end

endmodule
```

--- WARNING: Parsing Issues ---
Could not parse 'code' from LLM response. Expected ```code ... ``` block.(PARSE_ERROR)
