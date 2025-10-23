```thought
The finite-state machine can be designed with five states: Idle, Pattern_Detected, Shifting, Counting, and Done. 
- In the Idle state, the machine searches for the pattern 1101. 
- Once the pattern is detected, it transitions to Pattern_Detected, where it asserts shift_ena for exactly 4 clock cycles to shift in the duration bits. 
- After shifting, it transitions to Counting, where it asserts the counting output and waits for done_counting to go high. 
- Once done_counting is high, it transitions to Done, where it asserts the done output and waits for ack to go high. 
- Finally, when ack is high, it transitions back to Idle, ready to start the process again. 
The state machine will use a counter to keep track of the number of clock cycles it has been in the Shifting state.
```
```verilog
module TopModule(
    input  clk,
    input  reset,
    input  data,
    input  done_counting,
    input  ack,
    output shift_ena,
    output counting,
    output done
);

reg [2:0] state;
reg [1:0] shift_counter;
reg [3:0] pattern;
reg pattern_detected;

always @(posedge clk) begin
    if (reset) begin
        state <= 0;
        shift_counter <= 0;
        pattern <= 0;
        pattern_detected <= 0;
    end else begin
        case (state)
            0: begin // Idle
                if (pattern_detected) begin
                    state <= 1;
                    pattern_detected <= 0;
                end else begin
                    if (data) begin
                        pattern <= {pattern[2:0], 1'b1};
                    end else begin
                        pattern <= {pattern[2:0], 1'b0};
                    end
                    if (pattern == 4'b1101) begin
                        pattern_detected <= 1;
                    end else if (pattern != 4'b1101 && pattern != 0) begin
                        pattern <= 0;
                    end
                end
            end
            1: begin // Pattern_Detected
                shift_ena <= 1;
                shift_counter <= shift_counter + 1;
                if (shift_counter == 4) begin
                    shift_ena <= 0;
                    state <= 2;
                    shift_counter <= 0;
                end
            end
            2: begin // Shifting
                counting <= 1;
                if (done_counting) begin
                    state <= 3;
                    counting <= 0;
                end
            end
            3: begin // Counting
                done <= 1;
                if (ack) begin
                    state <= 0;
                    done <= 0;
                end
            end
            default: state <= 0;
        endcase
    end
end

endmodule
```

--- WARNING: Parsing Issues ---
Could not parse 'code' from LLM response. Expected ```code ... ``` block.(PARSE_ERROR)
