```thought
To implement the sequence detector, we will design a finite state machine (FSM) with five states: IDLE, S1, S2, S3, and S4. The FSM transitions through these states based on the input data_in. We will use a case statement to define the next state logic, and a parameterized always block to handle the current state and next state logic. The sequence_detected output will be set high when the FSM reaches the S4 state. The reset_n signal will be used to reset the FSM to the IDLE state.
```

```verilog
module sequence_detector (
    input clk,
    input reset_n,
    input data_in,
    output sequence_detected
);

// Define the states
parameter IDLE = 4'b0000;
parameter S1 = 4'b0001;
parameter S2 = 4'b0010;
parameter S3 = 4'b0100;
parameter S4 = 4'b1000;

// Declare the current state and next state registers
reg [3:0] current_state;
reg [3:0] next_state;

// Define the sequence detection output
reg sequence_detected_reg;

// Assign the output to a reg to avoid latch inference
assign sequence_detected = sequence_detected_reg;

// Next state logic
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
                next_state = S1;
            end
        end
        S2: begin
            if (data_in == 1'b0) begin
                next_state = S3;
            end else begin
                next_state = S1;
            end
        end
        S3: begin
            if (data_in == 1'b1) begin
                next_state = S4;
            end else begin
                next_state = S1;
            end
        end
        S4: begin
            next_state = IDLE;
        end
        default: begin
            next_state = IDLE;
        end
    endcase
end

// Current state logic
always @(posedge clk or negedge reset_n) begin
    if (~reset_n) begin
        current_state <= IDLE;
        sequence_detected_reg <= 1'b0;
    end else begin
        current_state <= next_state;
        if (current_state == S4) begin
            sequence_detected_reg <= 1'b1;
        end else begin
            sequence_detected_reg <= 1'b0;
        end
    end
end

endmodule
```

--- WARNING: Parsing Issues ---
Could not parse 'code' from LLM response. Expected ```code ... ``` block.(PARSE_ERROR)
