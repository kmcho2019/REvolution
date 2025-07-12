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

    // Sequential logic: pattern shift register and delay loading
    always @(posedge clk) begin
        if (reset) begin
            pattern_shift       <= 4'b0;
            delay_reg           <= 4'b0;
            delay_bits_received <= 3'd0;
        end else begin
            case (state)
                PATTERN_SEARCH: begin
                    // Shift in data to pattern register for pattern detection
                    pattern_shift <= {pattern_shift[2:0], data};
                    delay_bits_received <= 3'd0;
                    delay_reg <= 4'b0;
                end
                DELAY_LOAD: begin
                    // Shift in delay bits MSB first: insert data at LSB, shift left
                    delay_reg <= {delay_reg[2:0], data};
                    delay_bits_received <= delay_bits_received + 1'b1;
                    // pattern_shift unchanged during delay load
                end
                default: begin
                    // Hold pattern_shift and delay_reg steady
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
                if (pattern_matched) next_state = DELAY_LOAD;
                else next_state = PATTERN_SEARCH;
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

    // Sequential logic: state update and counters
    always @(posedge clk) begin
        if (reset) begin
            state          <= PATTERN_SEARCH;
            cycle_counter  <= 10'd0;
            tick_counter   <= 4'd0;
            count          <= 4'd0;
            counting       <= 1'b0;
            done           <= 1'b0;
        end else begin
            state <= next_state;

            case(state)
                PATTERN_SEARCH: begin
                    // No counting in this state
                    cycle_counter <= 10'd0;
                    tick_counter  <= 4'd0;
                    count         <= 4'd0;
                    counting      <= 1'b0;
                    done          <= 1'b0;
                end

                DELAY_LOAD: begin
                    // Still no counting
                    cycle_counter <= 10'd0;
                    tick_counter  <= 4'd0;
                    count         <= 4'd0;
                    counting      <= 1'b0;
                    done          <= 1'b0;
                end

                COUNT: begin
                    counting <= 1'b1;
                    done <= 1'b0;

                    // Initialize counters on entry to COUNT state
                    if (state != COUNT && next_state == COUNT) begin
                        // tick_counter counts intervals of 1000 cycles = delay + 1
                        tick_counter <= delay_reg + 1'b1;
                        cycle_counter <= 10'd0;
                        count <= delay_reg + 1'b1; // initial displayed count
                    end else begin
                        // Counting logic
                        if (cycle_counter == 10'd999) begin
                            cycle_counter <= 10'd0;
                            if (tick_counter != 0) begin
                                tick_counter <= tick_counter - 1'b1;
                            end
                            count <= tick_counter - 1'b1; // show remaining after decrement
                        end else begin
                            cycle_counter <= cycle_counter + 1'b1;
                            count <= tick_counter; // hold count steady during cycles
                        end
                    end
                end

                WAIT_ACK: begin
                    counting <= 1'b0;
                    done <= 1'b1;
                    count <= 4'bxxxx; // don't-care during done
                    cycle_counter <= 10'd0;
                    tick_counter <= 4'd0;
                end

                default: begin
                    // safe defaults
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