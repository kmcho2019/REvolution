```thought
To implement the finite-state machine, we will use a Moore machine approach, where the outputs are a function of the current state only. We can define five states: IDLE, PATTERN_MATCH, SHIFT, COUNT, and DONE. The IDLE state is the initial state where the machine searches for the pattern 1101. Once the pattern is detected, the machine transitions to the PATTERN_MATCH state. In this state, the machine asserts shift_ena for 4 clock cycles to shift in the duration bits. After that, it transitions to the COUNT state and asserts counting to wait for the counters to finish. Once done_counting is high, it transitions to the DONE state, asserts done, and waits for ack to reset. We will use a counter to keep track of the number of clock cycles shift_ena is asserted.
```

```verilog
module TopModule (
    input  clk,
    input  reset,
    input  data,
    input  done_counting,
    input  ack,
    output shift_ena,
    output counting,
    output done
);

reg [2:0] state; // IDLE, PATTERN_MATCH, SHIFT, COUNT, DONE
reg [1:0] shift_counter; // counter to track number of clock cycles shift_ena is asserted
reg [3:0] pattern_detector; // detector for pattern 1101

always @(posedge clk) begin
    if (reset) begin
        state <= 0; // IDLE
        shift_counter <= 0;
        pattern_detector <= 0;
    end else begin
        case (state)
            0: begin // IDLE
                if (pattern_detector == 4'b1101) begin
                    state <= 1; // PATTERN_MATCH
                    pattern_detector <= 0;
                end else begin
                    pattern_detector <= {data, pattern_detector[3:1]};
                end
            end
            1: begin // PATTERN_MATCH
                state <= 2; // SHIFT
                shift_counter <= 0;
                shift_ena <= 1'b1;
            end
            2: begin // SHIFT
                shift_counter <= shift_counter + 1;
                if (shift_counter == 4) begin
                    state <= 3; // COUNT
                    shift_ena <= 1'b0;
                end
            end
            3: begin // COUNT
                if (done_counting) begin
                    state <= 4; // DONE
                    counting <= 1'b0;
                end
            end
            4: begin // DONE
                if (ack) begin
                    state <= 0; // IDLE
                    done <= 1'b0;
                end
            end
        endcase
    end
end

always @(*) begin
    case (state)
        0, 1: begin // IDLE, PATTERN_MATCH
            counting <= 1'b0;
        end
        3: begin // COUNT
            counting <= 1'b1;
        end
        default: begin
            counting <= 1'b0;
        end
    endcase
end

always @(*) begin
    case (state)
        0, 1, 2, 3: begin // IDLE, PATTERN_MATCH, SHIFT, COUNT
            done <= 1'b0;
        end
        4: begin // DONE
            done <= 1'b1;
        end
    endcase
end

assign shift_ena = (state == 2) ? 1'b1 : 1'b0;

endmodule
```

--- WARNING: Parsing Issues ---
Could not parse 'code' from LLM response. Expected ```code ... ``` block.(PARSE_ERROR)
