```thought
To implement the sequence detector, I will use a finite state machine (FSM) with five states: IDLE, S1, S2, S3, and S4. The FSM will transition through these states based on the input data_in and will assert the output sequence_detected when the specific sequence 1001 is detected. The FSM will be implemented using a case statement to define the next state and output based on the current state and input. The reset_n signal will be used to initialize the FSM to the IDLE state.
```
```verilog
module sequence_detector(
    input clk,
    input reset_n,
    input data_in,
    output reg sequence_detected
);

// Define the states of the FSM
typedef enum logic [2:0] {
    IDLE = 3'b000,
    S1   = 3'b001,
    S2   = 3'b010,
    S3   = 3'b011,
    S4   = 3'b100
} state_t;

state_t current_state, next_state;

// Define the FSM transitions
always @(posedge clk or negedge reset_n) begin
    if (~reset_n) begin
        current_state <= IDLE;
        sequence_detected <= 1'b0;
    end else begin
        current_state <= next_state;
        if (current_state == S4) begin
            sequence_detected <= 1'b1;
        end else begin
            sequence_detected <= 1'b0;
        end
    end
end

// Define the next state logic
always @(*) begin
    case (current_state)
        IDLE: begin
            if (data_in == 1'b1) begin
                next_state <= IDLE;
            end else if (data_in == 1'b0) begin
                next_state <= S1;
            end
        end
        S1: begin
            if (data_in == 1'b0) begin
                next_state <= S2;
            end else if (data_in == 1'b1) begin
                next_state <= IDLE;
            end
        end
        S2: begin
            if (data_in == 1'b0) begin
                next_state <= S2;
            end else if (data_in == 1'b1) begin
                next_state <= S3;
            end
        end
        S3: begin
            if (data_in == 1'b0) begin
                next_state <= S1;
            end else if (data_in == 1'b1) begin
                next_state <= S4;
            end
        end
        S4: begin
            next_state <= IDLE;
        end
        default: next_state <= IDLE;
    endcase
end

endmodule
```
Note that this code uses a two-process FSM style, with one process for the state register and another process for the next state logic. The `always @(posedge clk or negedge reset_n)` process defines the state register and the `always @(*)` process defines the next state logic. The `case` statement inside the next state logic process defines the transitions between states based on the current state and input. The `sequence_detected` output is asserted when the FSM reaches the S4 state, indicating that the specific sequence 1001 has been detected.

--- WARNING: Parsing Issues ---
Could not parse 'code' from LLM response. Expected ```code ... ``` block.(PARSE_ERROR)
