module TopModule (
    input  wire       clk,
    input  wire       reset,   // synchronous active high
    input  wire       data,
    output reg [3:0]  count,
    output reg        counting,
    output reg        done,
    input  wire       ack
);

    // FSM states
    typedef enum reg [2:0] {
        IDLE       = 3'd0,  // Searching pattern 1101
        LOAD_DELAY = 3'd1,  // Shift in 4 delay bits (MSB first)
        COUNT      = 3'd2,  // Count delay * 1000 cycles
        DONE       = 3'd3   // Assert done, wait for ack
    } state_t;

    state_t state, next_state;

    // Pattern detection shift register for last 4 bits
    reg [3:0] pattern_shift;

    // Delay register (4 bits)
    reg [3:0] delay_reg;

    // Counter for bits loaded in LOAD_DELAY (0 to 4)
    reg [2:0] bits_loaded;

    // Cycle counter counts 0 to 999
    reg [9:0] cycle_counter;

    // Segment counter counts down from delay+1 to 0
    reg [4:0] segment_counter; // 5 bits to hold max 17

    // Next state logic combinational
    always @(*) begin
        case(state)
            IDLE: begin
                if (pattern_shift == 4'b1101)
                    next_state = LOAD_DELAY;
                else
                    next_state = IDLE;
            end

            LOAD_DELAY: begin
                if (bits_loaded == 3'd4)
                    next_state = COUNT;
                else
                    next_state = LOAD_DELAY;
            end

            COUNT: begin
                if (segment_counter == 5'd0 && cycle_counter == 10'd0)
                    next_state = DONE;
                else
                    next_state = COUNT;
            end

            DONE: begin
                if (ack)
                    next_state = IDLE;
                else
                    next_state = DONE;
            end

            default: next_state = IDLE;
        endcase
    end

    // Synchronous logic
    always @(posedge clk) begin
        if (reset) begin
            state         <= IDLE;
            pattern_shift <= 4'b0000;
            delay_reg     <= 4'b0000;
            bits_loaded   <= 3'd0;
            cycle_counter <= 10'd0;
            segment_counter <= 5'd0;
            count         <= 4'b0000;
            counting      <= 1'b0;
            done          <= 1'b0;
        end else begin
            state <= next_state;

            case(state)
                IDLE: begin
                    // Shift pattern register left by 1 bit, input data at LSB
                    pattern_shift <= {pattern_shift[2:0], data};
                    // Clear delay loading and counters
                    delay_reg     <= 4'b0000;
                    bits_loaded   <= 3'd0;
                    cycle_counter <= 10'd0;
                    segment_counter <= 5'd0;

                    // Outputs inactive
                    counting <= 1'b0;
                    done     <= 1'b0;
                    count    <= 4'b0000;
                end

                LOAD_DELAY: begin
                    // Hold pattern_shift (freeze pattern detection during load)
                    pattern_shift <= pattern_shift;

                    // Shift delay_reg left by 1 bit, data as LSB (MSB first)
                    delay_reg <= {delay_reg[2:0], data};
                    bits_loaded <= bits_loaded + 1;

                    // Counting and done inactive
                    counting <= 1'b0;
                    done <= 1'b0;
                    count <= 4'b0000;

                    // cycle_counter and segment_counter remain zero here
                    cycle_counter <= 10'd0;
                    segment_counter <= 5'd0;
                end

                COUNT: begin
                    // Pattern detection frozen
                    pattern_shift <= pattern_shift;
                    delay_reg <= delay_reg;
                    bits_loaded <= bits_loaded;

                    counting <= 1'b1;
                    done <= 1'b0;

                    // Count cycles 0..999, then decrement segment_counter
                    if (cycle_counter == 10'd0) begin
                        if (segment_counter != 5'd0) begin
                            // Finished one 1000-cycle segment, reload cycle_counter for next segment
                            segment_counter <= segment_counter - 1'b1;
                            cycle_counter <= 10'd999;
                        end else begin
                            // segment_counter and cycle_counter are zero -> done counting
                            segment_counter <= 5'd0;
                            cycle_counter <= 10'd0;
                        end
                    end else begin
                        cycle_counter <= cycle_counter - 1'b1;
                        segment_counter <= segment_counter;
                    end

                    // count output = segment_counter - 1 during counting (4 bits)
                    if (segment_counter != 5'd0)
                        count <= (segment_counter - 1'b1)[3:0];
                    else
                        count <= 4'b0000;
                end

                DONE: begin
                    // Clear pattern detection to prepare next pattern search after ack
                    pattern_shift <= 4'b0000;
                    delay_reg <= 4'b0000;
                    bits_loaded <= 3'd0;
                    cycle_counter <= 10'd0;
                    segment_counter <= 5'd0;

                    counting <= 1'b0;
                    done <= 1'b1;
                    count <= 4'b0000;
                end

                default: begin
                    // Safe default for all registers
                    pattern_shift <= 4'b0000;
                    delay_reg <= 4'b0000;
                    bits_loaded <= 3'd0;
                    cycle_counter <= 10'd0;
                    segment_counter <= 5'd0;
                    count <= 4'b0000;
                    counting <= 1'b0;
                    done <= 1'b0;
                end
            endcase

            // Initialize counters exactly at LOAD_DELAY -> COUNT transition
            if (state == LOAD_DELAY && next_state == COUNT) begin
                // segment_counter = delay + 1
                segment_counter <= delay_reg + 4'd1;
                cycle_counter <= 10'd999; // start first 1000-cycle segment at count=999 down to 0
            end
        end
    end

endmodule