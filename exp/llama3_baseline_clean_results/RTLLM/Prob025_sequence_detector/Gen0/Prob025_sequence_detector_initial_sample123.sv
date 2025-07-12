```thought
To implement the sequence detector, we'll design a finite state machine (FSM) with five states: IDLE, S1, S2, S3, and S4. The FSM will transition between these states based on the input data_in and will assert the sequence_detected output when the complete sequence 1001 is detected. The FSM will also be reset to the IDLE state when reset_n is high. We will use a case statement to handle the different states and their transitions. The sequence_detected output will be asserted only when the FSM reaches the S4 state.
```

```verilog
module sequence_detector(
    input clk,
    input reset_n,
    input data_in,
    output reg sequence_detected
);

// Enum for the states of the FSM
typedef enum logic [2:0] {
    IDLE = 3'b000,
    S1 = 3'b001,
    S2 = 3'b010,
    S3 = 3'b011,
    S4 = 3'b100
} state_t;

reg [2:0] current_state;

// Reset the state machine to IDLE when reset_n is high
always @(posedge clk or negedge reset_n) begin
    if (~reset_n) begin
        current_state <= IDLE;
        sequence_detected <= 1'b0;
    end else begin
        case (current_state)
            IDLE: begin
                if (data_in == 1'b1) begin
                    current_state <= S1;
                end else begin
                    current_state <= IDLE;
                end
            end
            S1: begin
                if (data_in == 1'b0) begin
                    current_state <= S2;
                end else begin
                    current_state <= IDLE;
                end
            end
            S2: begin
                if (data_in == 1'b0) begin
                    current_state <= S3;
                end else begin
                    current_state <= IDLE;
                end
            end
            S3: begin
                if (data_in == 1'b1) begin
                    current_state <= S4;
                end else begin
                    current_state <= IDLE;
                end
            end
            S4: begin
                current_state <= IDLE;
                sequence_detected <= 1'b1;
            end
            default: current_state <= IDLE;
        endcase
    end
end

// Assert sequence_detected only when in the S4 state
always @(posedge clk) begin
    if (current_state == S4) begin
        sequence_detected <= 1'b1;
    end else begin
        sequence_detected <= 1'b0;
    end
end

endmodule
```

--- WARNING: Parsing Issues ---
Could not parse 'code' from LLM response. Expected ```code ... ``` block.(PARSE_ERROR)
