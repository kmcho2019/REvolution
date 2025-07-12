```thought
To implement the sequence detector module, we will design a finite state machine (FSM) with five states: IDLE, S1, S2, S3, and S4. The state machine will transition through these states based on the input bitstream data_in. The sequence detection will be performed by checking the input data_in on each clock cycle and transitioning between states accordingly. Once the complete sequence is detected, the sequence_detected output will be asserted. The reset_n signal will be used to reset the state machine to the IDLE state when high.
```

```verilog
module sequence_detector(
    input clk,
    input reset_n,
    input data_in,
    output reg sequence_detected
);

// Define the states of the finite state machine
enum logic [2:0] {
    IDLE = 3'b000,
    S1 = 3'b001,
    S2 = 3'b010,
    S3 = 3'b011,
    S4 = 3'b100
} state, next_state;

// State register
always @(posedge clk or negedge reset_n) begin
    if (~reset_n) begin
        state <= IDLE;
    end else begin
        state <= next_state;
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
    endcase
end

// Output logic
always @(posedge clk) begin
    case (state)
        S4: begin
            sequence_detected <= 1'b1;
        end
        default: begin
            sequence_detected <= 1'b0;
        end
    endcase
end

endmodule
```

This Verilog implementation defines a sequence detector module named `sequence_detector` with the specified input and output ports. It uses a finite state machine to detect the specific 4-bit binary sequence `1001`. The state machine transitions through the states based on the input bitstream `data_in` and asserts the `sequence_detected` output when the complete sequence is detected. The reset signal `reset_n` is used to reset the state machine to the IDLE state when high.

--- WARNING: Parsing Issues ---
Could not parse 'code' from LLM response. Expected ```code ... ``` block.(PARSE_ERROR)
