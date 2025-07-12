```thought
To implement the sequence detector, we will design a finite state machine (FSM) with four states: IDLE, S1, S2, S3, and S4, where each state represents the detection of a specific bit in the 4-bit binary sequence 1001. The FSM will transition between states based on the input data_in and assert the sequence_detected signal when the complete sequence is detected. We will use a parameterized case statement to handle the state transitions and a conditional statement to set the sequence_detected output. The reset_n signal will be used to reset the FSM to the IDLE state when it is high.
```

```verilog
module sequence_detector (
    input clk,
    input reset_n,
    input data_in,
    output sequence_detected
);

// Define states
parameter IDLE = 4'd0;
parameter S1 = 4'd1;
parameter S2 = 4'd2;
parameter S3 = 4'd3;
parameter S4 = 4'd4;

// Declare current state and next state
reg [3:0] current_state;
reg [3:0] next_state;

// Initialize output
reg sequence_detected_reg;

// Assign output
assign sequence_detected = sequence_detected_reg;

// Sequential logic for state transitions
always @(posedge clk or negedge reset_n) begin
    if (~reset_n) begin
        current_state <= IDLE;
        sequence_detected_reg <= 1'b0;
    end else begin
        current_state <= next_state;
        if (next_state == S4) begin
            sequence_detected_reg <= 1'b1;
        end else begin
            sequence_detected_reg <= 1'b0;
        end
    end
end

// Combinational logic for next state
always @(*) begin
    case (current_state)
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
