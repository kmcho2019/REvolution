module TopModule (
    input  wire       clk,
    input  wire       reset,   // synchronous active-high reset
    input  wire       data,
    output reg [3:0]  count,
    output reg        counting,
    output reg        done,
    input  wire       ack
);

    // States encoding (one-hot for clarity or binary)
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
    reg [9:0] cycle_counter;  // counts 0..999 cycles
    reg [3:0] tick_counter;   // counts remaining 1000-cycle intervals

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

    // Sequential logic: state and outputs update
    always @(posedge clk) begin
        if (reset) begin
            // Reset all registers
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

            case(next_state)
                PATTERN_SEARCH: begin
                    // Clear pattern shift register and delay loading registers on entry
                    pattern_shift <= 4'b0;
                    delay_reg <= 4'b0;
                    delay_bits_received <= 3'd0;
                    counting <= 1'b0;
                    done <= 1'b0;
                    cycle_counter <= 10'd0;
                    tick_counter <= 4'd0;
                    count <= 4'bxxxx; // don't care
                    // Shift pattern register with new data every clock for pattern detection
                    pattern_shift <= {pattern_shift[2:0], data};
                end

                DELAY_LOAD: begin
                    counting <= 1'b0;
                    done <= 1'b0;
                    cycle_counter <= 10'd0;
                    tick_counter <= 4'd0;
                    count <= 4'bxxxx; // don't care

                    // Shift delay bits MSB-first: shift delay_reg left, insert data at LSB
                    delay_reg <= {delay_reg[2:0], data};
                    delay_bits_received <= delay_bits_received + 1'b1;

                    // Pattern shift register does not change here; no new pattern detection during delay loading
                    pattern_shift <= pattern_shift;
                end

                COUNT: begin
                    counting <= 1'b1;
                    done <= 1'b0;

                    // On entering COUNT state (from previous state not COUNT), initialize counters
                    if (state != COUNT) begin
                        cycle_counter <= 10'd0;
                        tick_counter <= delay_reg + 1'b1; // total intervals to count
                        count <= delay_reg;               // display remaining intervals minus 1
                        // pattern_shift and delay_regs hold last valid values but not used during counting
                    end else begin
                        // Increment cycle_counter every clock
                        if (cycle_counter == 10'd999) begin
                            cycle_counter <= 10'd0;
                            if (tick_counter > 0) begin
                                tick_counter <= tick_counter - 1'b1;
                                // Update count to remaining intervals - 1 after decrement
                                if (tick_counter > 1)
                                    count <= tick_counter - 2;
                                else
                                    count <= 4'd0;
                            end else begin
                                // tick_counter at 0: counting done, count 0
                                count <= 4'd0;
                            end
                        end else begin
                            cycle_counter <= cycle_counter + 1'b1;
                            // count holds current interval value steady during 1000 cycle period
                        end
                    end
                end

                WAIT_ACK: begin
                    counting <= 1'b0;
                    done <= 1'b1;
                    count <= 4'bxxxx; // don't care
                    cycle_counter <= 10'd0;
                    tick_counter <= 4'd0;
                    // Pattern shift and delay registers stay unchanged here
                end

                default: begin
                    // Default safe outputs
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