module TopModule (
    input  wire       clk,
    input  wire       reset,   // synchronous active-high reset
    input  wire       data,
    output reg [3:0]  count,
    output reg        counting,
    output reg        done,
    input  wire       ack
);

    // State encoding
    typedef enum logic [1:0] {
        PATTERN_SEARCH = 2'b00,
        DELAY_LOAD     = 2'b01,
        COUNT          = 2'b10,
        WAIT_ACK       = 2'b11
    } state_t;

    state_t state, next_state;

    // Shift register for pattern detection (4 bits)
    reg [3:0] pattern_shift;

    // Delay register to store delay bits (4 bits)
    reg [3:0] delay_reg;
    reg [2:0] delay_bits_received; // counts bits loaded into delay_reg (0-4)

    // Timer counters
    reg [9:0] cycle_counter;   // counts clock cycles 0-999 for 1000 cycle interval
    reg [3:0] tick_counter;    // counts how many 1000-cycle ticks left

    // Pattern detection signal
    wire pattern_matched = (pattern_shift == 4'b1101);

    // Detect entry into COUNT state to initialize counters once
    reg count_state_entered;

    // Sequential logic: pattern shift register and delay loading
    always @(posedge clk) begin
        if (reset) begin
            pattern_shift       <= 4'b0;
            delay_reg           <= 4'b0;
            delay_bits_received <= 3'd0;
        end else begin
            case (state)
                PATTERN_SEARCH: begin
                    // Shift in data to pattern register for pattern detection (1 bit each clk)
                    pattern_shift <= {pattern_shift[2:0], data};
                    // Do not clear delay_reg/delay_bits_received here to preserve delay bits if coming back
                end
                DELAY_LOAD: begin
                    // Shift in delay bits MSB first: shift left and put data in LSB
                    // First bit loaded becomes MSB after four shifts
                    delay_reg <= {delay_reg[2:0], data};
                    delay_bits_received <= delay_bits_received + 1'b1;
                end
                default: begin
                    // Hold pattern_shift and delay_reg steady in other states
                    pattern_shift <= pattern_shift;
                    delay_reg <= delay_reg;
                    delay_bits_received <= delay_bits_received;
                end
            endcase
        end
    end

    // Next state logic combinational
    always @(*) begin
        case(state)
            PATTERN_SEARCH: begin
                if (pattern_matched)
                    next_state = DELAY_LOAD;
                else
                    next_state = PATTERN_SEARCH;
            end
            DELAY_LOAD: begin
                if (delay_bits_received == 4)
                    next_state = COUNT;
                else
                    next_state = DELAY_LOAD;
            end
            COUNT: begin
                // When counting done (tick_counter==0 and cycle_counter==999), go to WAIT_ACK
                if ((tick_counter == 0) && (cycle_counter == 10'd999))
                    next_state = WAIT_ACK;
                else
                    next_state = COUNT;
            end
            WAIT_ACK: begin
                if (ack)
                    next_state = PATTERN_SEARCH;
                else
                    next_state = WAIT_ACK;
            end
            default: next_state = PATTERN_SEARCH;
        endcase
    end

    // Sequential logic: state update, counters, outputs
    always @(posedge clk) begin
        if (reset) begin
            state          <= PATTERN_SEARCH;
            cycle_counter  <= 10'd0;
            tick_counter   <= 4'd0;
            count          <= 4'd0;
            counting       <= 1'b0;
            done           <= 1'b0;
            count_state_entered <= 1'b0;
            pattern_shift  <= 4'b0;
            delay_reg      <= 4'b0;
            delay_bits_received <= 3'd0;
        end else begin
            state <= next_state;

            // Detect state entry into COUNT
            if ((state != COUNT) && (next_state == COUNT))
                count_state_entered <= 1'b1;
            else
                count_state_entered <= 1'b0;

            case(next_state)
                PATTERN_SEARCH: begin
                    // Reset counters and outputs when searching pattern
                    counting      <= 1'b0;
                    done          <= 1'b0;
                    cycle_counter <= 10'd0;
                    tick_counter  <= 4'd0;
                    count         <= 4'd0;
                    // pattern_shift and delay_reg updated above
                    // delay_bits_received reset only on reset, else retained
                end

                DELAY_LOAD: begin
                    counting      <= 1'b0;
                    done          <= 1'b0;
                    cycle_counter <= 10'd0;
                    tick_counter  <= 4'd0;
                    count         <= 4'd0;
                    // delay_reg and delay_bits_received updated above
                end

                COUNT: begin
                    counting <= 1'b1;
                    done <= 1'b0;

                    if (count_state_entered) begin
                        // Initialize counters on COUNT entry
                        tick_counter <= delay_reg + 1'b1; // number of 1000 cycle intervals
                        cycle_counter <= 10'd0;
                        count <= delay_reg; // Initially show delay (the number of remaining intervals -1)
                    end else begin
                        // Counting logic
                        if (cycle_counter == 10'd999) begin
                            cycle_counter <= 10'd0;
                            if (tick_counter > 0) begin
                                tick_counter <= tick_counter - 1'b1;
                                // count is the number of intervals left after decrement
                                // but count should show remaining time for the current 1000 cycles as the (tick_counter -1)
                                count <= (tick_counter > 1) ? (tick_counter - 2) : 4'd0;
                            end else begin
                                // tick_counter at 0 means counting finished, count stays 0
                                count <= 4'd0;
                            end
                        end else begin
                            cycle_counter <= cycle_counter + 1'b1;
                            // During counting cycles hold count steady to current displayed value
                            // It represents remaining intervals minus one.
                            // count updated only at interval boundaries above.
                        end
                    end
                end

                WAIT_ACK: begin
                    counting <= 1'b0;
                    done <= 1'b1;
                    count <= 4'bxxxx; // don't-care
                    cycle_counter <= 10'd0;
                    tick_counter <= 4'd0;
                    // Wait here until ack asserted
                end

                default: begin
                    counting <= 1'b0;
                    done <= 1'b0;
                    count <= 4'd0;
                    cycle_counter <= 10'd0;
                    tick_counter <= 4'd0;
                end
            endcase
        end
    end

endmodule