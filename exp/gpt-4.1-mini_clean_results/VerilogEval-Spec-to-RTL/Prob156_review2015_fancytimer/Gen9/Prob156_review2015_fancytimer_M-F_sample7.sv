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
    localparam [1:0]
        PATTERN_SEARCH = 2'b00,
        DELAY_LOAD     = 2'b01,
        COUNT          = 2'b10,
        WAIT_ACK       = 2'b11;

    reg [1:0] state, next_state;

    // Pattern detection shift register (4 bits)
    reg [3:0] pattern_shift;

    // Delay register and bit count
    reg [3:0] delay_reg;
    reg [2:0] delay_bits_received;

    // Counters for timing
    reg [9:0] cycle_counter;  // counts 0..999 cycles per interval
    reg [3:0] tick_counter;   // counts remaining intervals

    // Pattern matched signal
    wire pattern_matched = (pattern_shift == 4'b1101);

    // Next state combinational logic
    always @(*) begin
        case(state)
            PATTERN_SEARCH:
                if (pattern_matched)
                    next_state = DELAY_LOAD;
                else
                    next_state = PATTERN_SEARCH;

            DELAY_LOAD:
                if (delay_bits_received == 4)
                    next_state = COUNT;
                else
                    next_state = DELAY_LOAD;

            COUNT:
                // Transition when finished counting all intervals of 1000 cycles
                if ((tick_counter == 0) && (cycle_counter == 10'd999))
                    next_state = WAIT_ACK;
                else
                    next_state = COUNT;

            WAIT_ACK:
                if (ack)
                    next_state = PATTERN_SEARCH;
                else
                    next_state = WAIT_ACK;

            default:
                next_state = PATTERN_SEARCH;
        endcase
    end

    // Sequential logic: state, outputs, and registers update
    always @(posedge clk) begin
        if (reset) begin
            // Reset all registers synchronously
            state <= PATTERN_SEARCH;
            pattern_shift <= 4'b0;
            delay_reg <= 4'b0;
            delay_bits_received <= 3'd0;
            cycle_counter <= 10'd0;
            tick_counter <= 4'd0;
            count <= 4'b0;
            counting <= 1'b0;
            done <= 1'b0;
        end else begin
            state <= next_state;

            case(state)
                PATTERN_SEARCH: begin
                    // Shift pattern detection register every clock, no reset here
                    // This advances the 4-bit window for pattern detection
                    pattern_shift <= {pattern_shift[2:0], data};

                    // Clear delay loading registers on PATTERN_SEARCH
                    delay_reg <= 4'b0;
                    delay_bits_received <= 3'd0;

                    // Clear counters and outputs
                    cycle_counter <= 10'd0;
                    tick_counter <= 4'd0;
                    count <= 4'bxxxx;  // don't care
                    counting <= 1'b0;
                    done <= 1'b0;
                end

                DELAY_LOAD: begin
                    // Keep pattern_shift stable during delay load
                    // Load delay bits MSB-first: shift left by 1, data into LSB
                    delay_reg <= {delay_reg[2:0], data};

                    // Count number of delay bits received
                    delay_bits_received <= delay_bits_received + 1'b1;

                    // Outputs inactive during delay load
                    counting <= 1'b0;
                    done <= 1'b0;
                    cycle_counter <= 10'd0;
                    tick_counter <= 4'd0;
                    count <= 4'bxxxx;  // don't care

                    // pattern_shift stays unchanged to avoid false pattern match here
                    pattern_shift <= pattern_shift;
                end

                COUNT: begin
                    // Assert counting during COUNT state
                    counting <= 1'b1;
                    done <= 1'b0;

                    // On entering COUNT state (previous state not COUNT), initialize counters
                    if (state != COUNT) begin
                        cycle_counter <= 10'd0;
                        tick_counter <= delay_reg + 1'b1; // total intervals = delay+1
                        count <= delay_reg;               // initial remaining intervals - 1
                        // pattern_shift and delay_reg hold values but unused here
                    end else begin
                        // Increment cycle_counter each clock
                        if (cycle_counter == 10'd999) begin
                            // One 1000-cycle interval finished
                            cycle_counter <= 10'd0;
                            if (tick_counter > 0)
                                tick_counter <= tick_counter - 1'b1;

                            // Update count output to show remaining intervals during the next 1000 cycles
                            // After decrementing tick_counter, count = tick_counter - 1 but clamp at 0
                            if (tick_counter > 1)
                                count <= tick_counter - 2;
                            else
                                count <= 4'd0;
                        end else begin
                            cycle_counter <= cycle_counter + 1'b1;
                            // count output stays constant during each 1000-cycle interval
                        end
                    end
                end

                WAIT_ACK: begin
                    // Assert done, deassert counting
                    done <= 1'b1;
                    counting <= 1'b0;

                    // count is don't care here
                    count <= 4'bxxxx;

                    // Reset counters
                    cycle_counter <= 10'd0;
                    tick_counter <= 4'd0;

                    // pattern_shift and delay_reg remain stable until next PATTERN_SEARCH entry
                end

                default: begin
                    // Safe default values
                    counting <= 1'b0;
                    done <= 1'b0;
                    count <= 4'b0;
                    pattern_shift <= 4'b0;
                    delay_reg <= 4'b0;
                    delay_bits_received <= 3'd0;
                    cycle_counter <= 10'd0;
                    tick_counter <= 4'd0;
                end
            endcase
        end
    end

endmodule