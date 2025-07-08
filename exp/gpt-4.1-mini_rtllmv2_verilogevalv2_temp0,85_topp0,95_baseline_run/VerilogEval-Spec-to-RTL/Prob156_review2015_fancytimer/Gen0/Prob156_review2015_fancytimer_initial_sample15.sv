module TopModule (
    input clk,
    input reset,
    input data,
    output reg [3:0] count,
    output reg counting,
    output reg done,
    input ack
);

    // FSM states
    typedef enum logic [1:0] {
        IDLE = 2'b00,
        READ_DELAY = 2'b01,
        COUNTING = 2'b10,
        DONE = 2'b11
    } state_t;

    state_t state, next_state;

    // Shift register for pattern detection and delay input
    reg [3:0] pattern_shift;
    reg [3:0] delay;

    // Counters for counting clock cycles and delay count
    reg [9:0] cycle_count;  // counts up to 1000 cycles (0 to 999)
    reg [3:0] delay_count;  // counts down from delay to 0

    // For counting bits read in READ_DELAY
    reg [2:0] bit_index;  // counts from 0 to 3

    // Sequential logic for state transitions and counters
    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            pattern_shift <= 4'b0000;
            delay <= 4'b0000;
            cycle_count <= 10'd0;
            delay_count <= 4'd0;
            bit_index <= 3'd0;
            counting <= 1'b0;
            done <= 1'b0;
            count <= 4'd0;
        end else begin
            state <= next_state;

            case (state)
                IDLE: begin
                    done <= 1'b0;
                    counting <= 1'b0;
                    count <= 4'd0;

                    // Shift in data for pattern detection
                    pattern_shift <= {pattern_shift[2:0], data};
                end

                READ_DELAY: begin
                    done <= 1'b0;
                    counting <= 1'b0;

                    // Shift in delay bits MSB first:
                    // shift delay left by 1, then set LSB with data
                    delay <= {delay[2:0], data};

                    bit_index <= bit_index + 1;
                end

                COUNTING: begin
                    done <= 1'b0;
                    counting <= 1'b1;

                    // cycle_count increments each clock cycle
                    if (cycle_count == 10'd999) begin
                        cycle_count <= 10'd0;
                        // One 1000-cycle period done, decrement delay_count if > 0
                        if (delay_count != 0)
                            delay_count <= delay_count - 1;
                    end else begin
                        cycle_count <= cycle_count + 1;
                    end

                    // count output shows current remaining time
                    count <= delay_count;
                end

                DONE: begin
                    done <= 1'b1;
                    counting <= 1'b0;
                    count <= 4'd0;
                    // Wait for ack to return to IDLE handled in next_state logic
                end

                default: begin
                    // Should not occur, reset outputs
                    done <= 1'b0;
                    counting <= 1'b0;
                    count <= 4'd0;
                end
            endcase
        end
    end

    // Combinational logic for next_state
    always @(*) begin
        next_state = state;  // default hold

        case (state)
            IDLE: begin
                // Wait until pattern_shift == 1101
                if (pattern_shift == 4'b1101) begin
                    next_state = READ_DELAY;
                end
            end

            READ_DELAY: begin
                // After reading 4 bits of delay, go to COUNTING
                if (bit_index == 3) begin
                    next_state = COUNTING;
                end
            end

            COUNTING: begin
                // When delay_count and cycle_count both reach 0, counting done
                if (delay_count == 0 && cycle_count == 10'd999) begin
                    next_state = DONE;
                end
            end

            DONE: begin
                // Wait for ack=1 to return to IDLE and restart searching
                if (ack) begin
                    next_state = IDLE;
                end
            end

            default: next_state = IDLE;
        endcase
    end

    // Additional sequential logic for initializing counters on state transitions
    always @(posedge clk) begin
        if (reset) begin
            // Already handled above
        end else begin
            if (state != next_state) begin
                case (next_state)
                    IDLE: begin
                        pattern_shift <= 4'b0000;
                        bit_index <= 3'd0;
                    end
                    READ_DELAY: begin
                        // bit_index reset in IDLE->READ_DELAY or incremented in READ_DELAY state
                        bit_index <= 3'd0;
                        delay <= 4'b0000;
                    end
                    COUNTING: begin
                        // Initialize counters
                        cycle_count <= 10'd0;
                        delay_count <= delay;
                    end
                    DONE: begin
                        // nothing to init here
                    end
                endcase
            end
        end
    end

endmodule