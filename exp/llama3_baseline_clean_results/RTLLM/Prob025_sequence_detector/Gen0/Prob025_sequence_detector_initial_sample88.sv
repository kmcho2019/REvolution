```thought
To implement the sequence detector module, we'll design a finite state machine (FSM) with five states: IDLE, S1, S2, S3, and S4. The FSM will transition through these states based on the input bitstream data_in. The state machine will start in the IDLE state and check for the first bit of the sequence. If the bit matches, it will move to the next state; otherwise, it will remain in the IDLE state. This process will continue until the entire sequence is detected, at which point the sequence_detected output will be set high. The FSM will also have a reset functionality to return to the IDLE state when the reset signal is high.
```

```verilog
module sequence_detector(
    input clk,
    input reset_n,
    input data_in,
    output reg sequence_detected
);

// Define the states of the FSM
enum logic [2:0] {
    IDLE = 3'b000,
    S1   = 3'b001,
    S2   = 3'b010,
    S3   = 3'b011,
    S4   = 3'b100
} state, next_state;

// Initialize the output
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

// Define the next state logic
always @(*) begin
    case (state)
        IDLE: begin
            if (data_in == 1'b1) begin
                next_state <= S1;
            end else begin
                next_state <= IDLE;
            end
        end
        S1: begin
            if (data_in == 1'b0) begin
                next_state <= S2;
            end else begin
                next_state <= IDLE;
            end
        end
        S2: begin
            if (data_in == 1'b0) begin
                next_state <= S3;
            end else begin
                next_state <= IDLE;
            end
        end
        S3: begin
            if (data_in == 1'b1) begin
                next_state <= S4;
            end else begin
                next_state <= IDLE;
            end
        end
        S4: begin
            next_state <= IDLE;
        end
        default: begin
            next_state <= IDLE;
        end
    endcase
end

endmodule
```

--- WARNING: Parsing Issues ---
Could not parse 'code' from LLM response. Expected ```code ... ``` block.(PARSE_ERROR)
