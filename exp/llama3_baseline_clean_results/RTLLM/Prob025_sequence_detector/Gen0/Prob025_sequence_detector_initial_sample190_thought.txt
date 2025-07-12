```thought
To implement the sequence detector, we will design a finite state machine (FSM) with five states: IDLE, S1, S2, S3, and S4. The FSM transitions between these states based on the input bitstream data_in. The sequence_detected output is asserted when the FSM reaches the S4 state, indicating that the specific 4-bit binary sequence 1001 has been detected. We will use a always_ff block to define the FSM's next state logic and a always_comb block to define the output logic. The reset_n signal will be used to reset the FSM to the IDLE state when it is high.
```

```verilog
module sequence_detector(
    input clk,
    input reset_n,
    input data_in,
    output sequence_detected
);

// Define the states of the FSM
typedef enum logic [2:0] {
    IDLE = 3'b000,
    S1 = 3'b001,
    S2 = 3'b010,
    S3 = 3'b011,
    S4 = 3'b100
} state_t;

// Define the current and next state
state_t current_state, next_state;

// Define the output
logic sequence_detected_int;

// Define the FSM's next state logic
always_ff @(posedge clk or negedge reset_n) begin
    if (~reset_n) begin
        current_state <= IDLE;
    end else begin
        current_state <= next_state;
    end
end

// Define the FSM's next state and output logic
always_comb begin
    next_state = current_state;
    sequence_detected_int = 1'b0;
    
    case (current_state)
        IDLE: begin
            if (data_in == 1'b1) begin
                next_state = S1;
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
            sequence_detected_int = 1'b1;
            next_state = IDLE;
        end
    endcase
end

// Assign the output
assign sequence_detected = sequence_detected_int;

endmodule
```

--- WARNING: Parsing Issues ---
Could not parse 'code' from LLM response. Expected ```code ... ``` block.(PARSE_ERROR)
