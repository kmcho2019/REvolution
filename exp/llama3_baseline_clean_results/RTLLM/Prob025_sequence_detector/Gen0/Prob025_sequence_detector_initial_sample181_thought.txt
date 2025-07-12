```thought
To implement the sequence detector, we will design a finite state machine (FSM) with five states: IDLE, S1, S2, S3, and S4. The FSM will transition between these states based on the input bitstream data_in. The sequence_detected signal will be asserted when the FSM reaches the S4 state, indicating that the specific 4-bit binary sequence 1001 has been detected. The FSM will be reset to the IDLE state when the reset_n signal is low. We will use a 2-bit state register to encode the five states, with the encoding: IDLE=00, S1=01, S2=10, S3=11, and S4 will be handled by checking the current state and the input data_in.
```
```verilog
module sequence_detector(
    input clk,
    input reset_n,
    input data_in,
    output reg sequence_detected
);

reg [1:0] state;

localparam IDLE = 2'b00;
localparam S1 = 2'b01;
localparam S2 = 2'b10;
localparam S3 = 2'b11;

always @ (posedge clk or negedge reset_n) begin
    if (~reset_n) begin
        state <= IDLE;
        sequence_detected <= 1'b0;
    end else begin
        case (state)
            IDLE: begin
                if (data_in == 1'b1) begin
                    state <= S1;
                end else begin
                    state <= IDLE;
                end
            end
            S1: begin
                if (data_in == 1'b0) begin
                    state <= S2;
                end else begin
                    state <= IDLE;
                end
            end
            S2: begin
                if (data_in == 1'b0) begin
                    state <= S3;
                end else begin
                    state <= IDLE;
                end
            end
            S3: begin
                if (data_in == 1'b1) begin
                    state <= IDLE;
                    sequence_detected <= 1'b1;
                end else begin
                    state <= IDLE;
                end
            end
            default: begin
                state <= IDLE;
            end
        endcase
    end
end

always @ (posedge clk) begin
    if (state == S3 && data_in == 1'b1) begin
        sequence_detected <= 1'b1;
    end else begin
        sequence_detected <= 1'b0;
    end
end

endmodule
```

--- WARNING: Parsing Issues ---
Could not parse 'code' from LLM response. Expected ```code ... ``` block.(PARSE_ERROR)
