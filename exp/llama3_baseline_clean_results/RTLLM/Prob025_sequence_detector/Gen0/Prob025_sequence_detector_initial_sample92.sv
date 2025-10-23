```thought
To implement the sequence detector, we will design a finite state machine (FSM) with five states: IDLE, S1, S2, S3, and S4. The FSM will transition between these states based on the input bitstream data_in. We will use a 2-bit state register to represent the current state. The sequence detection logic will check the input data_in and the current state to determine the next state. The sequence_detected output will be set high when the complete sequence is detected. We will also include a reset mechanism to return the FSM to the IDLE state when reset_n is low.
```

```verilog
module sequence_detector(
    input clk,
    input reset_n,
    input data_in,
    output reg sequence_detected
);

// Define the states of the FSM
enum logic [1:0] {
    IDLE = 2'b00,
    S1 = 2'b01,
    S2 = 2'b10,
    S3 = 2'b11
} state, next_state;

// FSM logic
always @(*) begin
    case(state)
        IDLE: begin
            if(data_in == 1'b1) begin
                next_state = S1;
            end else begin
                next_state = IDLE;
            end
        end
        S1: begin
            if(data_in == 1'b0) begin
                next_state = S2;
            end else begin
                next_state = S1;
            end
        end
        S2: begin
            if(data_in == 1'b0) begin
                next_state = S3;
            end else begin
                next_state = S1;
            end
        end
        S3: begin
            if(data_in == 1'b1) begin
                next_state = IDLE;
                sequence_detected = 1'b1;
            end else begin
                next_state = S1;
            end
        end
        default: next_state = IDLE;
    endcase
end

// Sequence detection and FSM update
always @(posedge clk or negedge reset_n) begin
    if(~reset_n) begin
        state <= IDLE;
        sequence_detected <= 1'b0;
    end else begin
        state <= next_state;
        if(sequence_detected == 1'b1) begin
            sequence_detected <= 1'b0;
        end
    end
end

endmodule
```

--- WARNING: Parsing Issues ---
Could not parse 'code' from LLM response. Expected ```code ... ``` block.(PARSE_ERROR)
