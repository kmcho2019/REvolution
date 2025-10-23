```thought
The sequence detector will be implemented as a finite state machine (FSM) with five states: IDLE, S1, S2, S3, and S4. The FSM will transition between these states based on the input data_in. The sequence detection process starts in the IDLE state, where it waits for the first bit of the sequence (1). Upon detecting a '1', it moves to state S1. Then, it checks for the next bit in the sequence (0), and if it matches, it transitions to state S2. This process continues until the complete sequence (1001) is detected, at which point it transitions to state S4 and asserts the sequence_detected output. If at any point the input bit does not match the expected sequence, the FSM returns to the IDLE state. The reset_n signal is used to reset the FSM to the IDLE state when it is asserted low.
```
```verilog
module sequence_detector(
    input           clk,
    input           reset_n,
    input           data_in,
    output          sequence_detected
);

// Enumerate states
enum logic [2:0] {IDLE, S1, S2, S3, S4} state, next_state;

// Output assignment
assign sequence_detected = (state == S4);

// State register
always_ff @(posedge clk or negedge reset_n) begin
    if (~reset_n) begin
        state <= IDLE;
    end else begin
        state <= next_state;
    end
end

// Next state logic
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
            end else if (data_in == 1'b1) begin
                next_state = S1;
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
This Verilog implementation describes a sequence detector that uses a finite state machine to detect the binary sequence 1001. It includes an asynchronous reset that returns the state machine to the IDLE state when asserted. The detector asserts the `sequence_detected` output when the complete sequence is detected.

--- WARNING: Parsing Issues ---
Could not parse 'code' from LLM response. Expected ```code ... ``` block.(PARSE_ERROR)
