```thought
The finite-state machine can be designed with five states: IDLE, PATTERN_DETECTED, SHIFTING, COUNTING, and DONE. 
The state machine starts in the IDLE state, where it waits for the pattern 1101 to be detected on the data input pin. 
When the pattern is detected, it transitions to the PATTERN_DETECTED state, where it asserts shift_ena for exactly 4 clock cycles. 
After that, it transitions to the COUNTING state, where it asserts counting and waits for the counters to finish counting. 
Once the counters are done, it transitions to the DONE state, where it asserts done and waits for the user to acknowledge the timer. 
Finally, when the user acknowledges the timer, it transitions back to the IDLE state, resetting the state machine.
```
```verilog
module TopModule(
    input  clk,
    input  reset,
    input  data,
    input  done_counting,
    input  ack,
    output reg shift_ena,
    output reg counting,
    output reg done
);

reg [1:0] state;
reg [3:0] shift_count;
reg [3:0] pattern_detector;

always @(posedge clk) begin
    if (reset) begin
        state <= 0;
        shift_ena <= 0;
        counting <= 0;
        done <= 0;
        shift_count <= 0;
        pattern_detector <= 0;
    end
    else begin
        case (state)
            0: // IDLE state
                begin
                    shift_ena <= 0;
                    counting <= 0;
                    done <= 0;
                    if (pattern_detector == 4'b1101) begin
                        state <= 1;
                        pattern_detector <= 0;
                    end
                    else begin
                        pattern_detector <= {pattern_detector[2:0], data};
                    end
                end
            1: // PATTERN_DETECTED state
                begin
                    shift_ena <= 1;
                    if (shift_count == 4) begin
                        state <= 2;
                        shift_count <= 0;
                        shift_ena <= 0;
                    end
                    else begin
                        shift_count <= shift_count + 1;
                    end
                end
            2: // SHIFTING state
                begin
                    counting <= 1;
                    if (done_counting) begin
                        state <= 3;
                    end
                end
            3: // COUNTING state
                begin
                    counting <= 1;
                    if (done_counting) begin
                        state <= 4;
                    end
                end
            4: // DONE state
                begin
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
