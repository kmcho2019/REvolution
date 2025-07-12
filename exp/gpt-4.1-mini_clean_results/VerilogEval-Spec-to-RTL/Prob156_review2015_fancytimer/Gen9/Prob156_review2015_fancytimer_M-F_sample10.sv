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
    reg [2:0] delay_bits_received; // counts 0..4

    // Counters for timing
    reg [9:0] cycle_counter;  // counts 0..999 cycles
    reg [3:0] tick_counter;   // counts remaining 1000-cycle intervals

    wire pattern_matched = (pattern_shift == 4'b1101);

    // Next state logic combinational
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
                // Transition after finishing last 1000-cycle interval
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
            state <= PATTERN_SEARCH;

            pattern_shift <= 4'b0;
            delay_reg <= 4'b0;
            delay_bits_received <= 3'd0;
            cycle_counter <= 10'd0;
            tick_counter <= 4'd0;

            count <= 4'bxxxx;
            counting <= 1'b0;
            done <= 1'b0;
        end else begin
            state <= next_state;

            case(state)
                PATTERN_SEARCH: begin
                    counting <= 1'b0;
                    done <= 1'b0;
                    count <= 4'bxxxx;

                    // Shift pattern register left, insert new bit at LSB
                    // Do NOT clear pattern_shift here, just shift in
                    pattern_shift <= {pattern_shift[2:0], data};

                    // Clear delay bit counter and delay_reg for future use
                    delay_bits_received <= 3'd0;
                    delay_reg <= 4'b0;
                    cycle_counter <= 10'd0;
                    tick_counter <= 4'd0;
                end

                DELAY_LOAD: begin
                    counting <= 1'b0;
                    done <= 1'b0;
                    count <= 4'bxxxx;

                    // Shift delay bits MSB-first into delay_reg:
                    // shift delay_reg left by 1, insert data at LSB
                    delay_reg <= {delay_reg[2:0], data};

                    // Increment delay bits received
                    delay_bits_received <= delay_bits_received + 1'b1;

                    // Do NOT shift pattern_shift here; ignore pattern detection during delay load
                    pattern_shift <= pattern_shift;

                    cycle_counter <= 10'd0;
                    tick_counter <= 4'd0;
                end

                COUNT: begin
                    counting <= 1'b1;
                    done <= 1'b0;

                    // Initialize counters at state entry
                    if (state != COUNT) begin
                        cycle_counter <= 10'd0;
                        tick_counter <= delay_reg + 1'b1; // total intervals to count
                        count <= delay_reg;                // count shows remaining intervals minus current one
                    end else begin
                        // Increment cycle_counter every clock
                        if (cycle_counter == 10'd999) begin
                            cycle_counter <= 10'd0;
                            if (tick_counter > 0) begin
                                tick_counter <= tick_counter - 1'b1;
                                // Update count to remaining intervals - 1
                                if (tick_counter > 1)
                                    count <= tick_counter - 2;
                                else
                                    count <= 4'd0;
                            end else begin
                                // tick_counter zero means counting done, keep count at zero
                                count <= 4'd0;
                            end
                        end else begin
                            cycle_counter <= cycle_counter + 1'b1;
                            // count holds steady during the 1000-cycle interval
                        end
                    end
                    // pattern_shift, delay_reg not modified in COUNT state
                end

                WAIT_ACK: begin
                    counting <= 1'b0;
                    done <= 1'b1;
                    count <= 4'bxxxx;

                    // Clear registers to avoid false pattern detection after ACK
                    if (state != WAIT_ACK) begin
                        pattern_shift <= 4'b0;
                        delay_reg <= 4'b0;
                        delay_bits_received <= 3'd0;
                    end

                    cycle_counter <= 10'd0;
                    tick_counter <= 4'd0;
                end

                default: begin
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