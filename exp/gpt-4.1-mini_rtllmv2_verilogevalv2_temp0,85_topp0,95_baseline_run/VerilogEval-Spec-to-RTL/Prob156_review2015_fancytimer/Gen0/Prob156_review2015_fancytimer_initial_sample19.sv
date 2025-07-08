module TopModule(
    input clk,
    input reset,
    input data,
    output reg [3:0] count,
    output reg counting,
    output reg done,
    input ack
);

    // States encoding
    localparam SEARCH      = 2'd0;
    localparam SHIFT_DELAY = 2'd1;
    localparam COUNTING    = 2'd2;
    localparam DONE        = 2'd3;

    reg [1:0] state, next_state;

    // Shift register for detecting start pattern (4 bits)
    reg [3:0] pattern_shift;

    // Delay register (4 bits)
    reg [3:0] delay;

    // Shift counter (counts bits shifted for delay)
    reg [2:0] shift_count; // up to 4

    // Timer counters
    reg [9:0] cycle_count;   // counts 0..999 (1000 cycles)
    reg [3:0] delay_count;   // countdown from delay down to 0

    // Pattern to detect: 1101 (binary 4'b1101)
    localparam START_PATTERN = 4'b1101;

    // Sequential logic and FSM state update
    always @(posedge clk) begin
        if (reset) begin
            state <= SEARCH;
            pattern_shift <= 4'b0000;
            delay <= 4'b0000;
            shift_count <= 3'd0;
            cycle_count <= 10'd0;
            delay_count <= 4'd0;
            counting <= 1'b0;
            done <= 1'b0;
            count <= 4'bxxxx; // don't care
        end else begin
            state <= next_state;

            case(state)
                SEARCH: begin
                    done <= 1'b0;
                    counting <= 1'b0;
                    count <= 4'bxxxx; // don't care
                    // Shift in data to detect start pattern
                    pattern_shift <= {pattern_shift[2:0], data};
                end

                SHIFT_DELAY: begin
                    done <= 1'b0;
                    counting <= 1'b0;
                    // Shift in next 4 bits MSB first to delay
                    // pattern_shift not needed here
                    if (shift_count < 3'd4) begin
                        delay <= {delay[2:0], data};
                        shift_count <= shift_count + 1'b1;
                    end
                end

                COUNTING: begin
                    done <= 1'b0;
                    counting <= 1'b1;
                    // count outputs current remaining delay_count
                    count <= delay_count;
                    // cycle counter increments each clock
                    if (cycle_count == 10'd999) begin
                        cycle_count <= 10'd0;
                        if (delay_count != 0)
                            delay_count <= delay_count - 1'b1;
                    end else begin
                        cycle_count <= cycle_count + 1'b1;
                    end
                end

                DONE: begin
                    counting <= 1'b0;
                    done <= 1'b1;
                    count <= 4'bxxxx; // don't care
                    // wait for ack, no other updates
                end

                default: begin
                    // Should not occur
                    state <= SEARCH;
                    counting <= 1'b0;
                    done <= 1'b0;
                    count <= 4'bxxxx;
                end
            endcase
        end
    end

    // Next state logic
    always @(*) begin
        next_state = state;
        case(state)
            SEARCH: begin
                // If pattern_shift matches 1101, go to SHIFT_DELAY
                if (pattern_shift == START_PATTERN)
                    next_state = SHIFT_DELAY;
                else
                    next_state = SEARCH;
            end

            SHIFT_DELAY: begin
                if (shift_count == 3'd4)
                    next_state = COUNTING;
                else
                    next_state = SHIFT_DELAY;
            end

            COUNTING: begin
                // When finished counting the last 1000 cycles of delay_count=0, go to DONE
                if ((delay_count == 0) && (cycle_count == 10'd999))
                    next_state = DONE;
                else
                    next_state = COUNTING;
            end

            DONE: begin
                // Wait for ack == 1 to return to SEARCH
                if (ack)
                    next_state = SEARCH;
                else
                    next_state = DONE;
            end

            default: next_state = SEARCH;
        endcase
    end

    // Reset shift_count and delay_count at appropriate times
    always @(posedge clk) begin
        if (reset) begin
            shift_count <= 3'd0;
            delay_count <= 4'd0;
        end else begin
            case(state)
                SEARCH: begin
                    shift_count <= 3'd0;
                    delay_count <= 4'd0;
                end
                SHIFT_DELAY: begin
                    // shift_count increments in main sequential block
                    // do nothing here
                end
                COUNTING: begin
                    if (state != next_state) begin
                        // Transition into COUNTING: initialize counters
                        delay_count <= delay;
                        cycle_count <= 10'd0;
                    end
                end
                DONE: begin
                    // nothing special
                end
            endcase
        end
    end

endmodule