```thought
To implement a sequence detector in Verilog, we'll define a finite state machine (FSM) with five states: IDLE, S1, S2, S3, and S4. The FSM transitions between these states based on the input data_in and current state. The detector starts in the IDLE state, waiting for the first bit of the sequence (1) to arrive. Upon detecting each subsequent bit of the sequence (0, 0, 1), the FSM transitions to the next state. Once the complete sequence (1001) is detected, the FSM asserts the sequence_detected output. A reset_n signal is used to reset the FSM to the IDLE state when needed.
```
```verilog
module sequence_detector(
    input clk,
    input reset_n,
    input data_in,
    output sequence_detected
);

// Define the states of the FSM
enum logic [2:0] {
    IDLE = 3'b000,
    S1 = 3'b001,
    S2 = 3'b010,
    S3 = 3'b011,
    S4 = 3'b100
} state, next_state;

// Default output assignment
assign sequence_detected = (state == S4);

// Sequential logic for the FSM
always_ff @(posedge clk or negedge reset_n) begin
    if (!reset_n) begin
        state <= IDLE;
    end else begin
        state <= next_state;
    end
end

// Combinational logic for the FSM
always_comb begin
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
        default: next_state = IDLE;
    endcase
end

endmodule
```

--- WARNING: Parsing Issues ---
Could not parse 'code' from LLM response. Expected ```code ... ``` block.(PARSE_ERROR)
