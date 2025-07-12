module TopModule (
    input        clk,
    input        reset,   // synchronous active high
    input        data,
    output reg [3:0] count,
    output reg   counting,
    output reg   done,
    input        ack
);

    // FSM states
    typedef enum logic [1:0] {
        SEARCH     = 2'd0,
        DELAY_LOAD = 2'd1,
        COUNT      = 2'd2,
        WAIT_ACK   = 2'd3
    } state_t;

    state_t state, next_state;

    // Shift register for pattern detection (only in SEARCH)
    reg [3:0] pattern_shift;

    // Delay register and bit counter
    reg [3:0] delay_reg;
    reg [2:0] delay_bits_loaded; // counts 0..4 bits loaded

    // Counters for timing
    reg [9:0] cycle_counter;    // counts 0..999 (for 1000 cycles)
    reg [3:0] tick_counter;     // counts down from delay to 0

    localparam [3:0] START_PATTERN = 4'b1101;

    // Sequential logic - single always block
    always @(posedge clk) begin
        if (reset) begin
            // Reset everything
            state <= SEARCH;
            pattern_shift <= 4'd0;
            delay_reg <= 4'd0;
            delay_bits_loaded <= 3'd0;
            cycle_counter <= 10'd0;
            tick_counter <= 4'd0;
            count <= 4'd0;
            counting <= 1'b0;
            done <= 1'b0;
        end else begin
            // Default next state = current state (safe fallback)
            next_state = state;

            case (state)
                SEARCH: begin
                    // Shift pattern register left, input bit to LSB to detect pattern MSB-first
                    pattern_shift <= {pattern_shift[2:0], data};

                    // Outputs and counters default
                    counting <= 1'b0;
                    done <= 1'b0;
                    count <= 4'd0;

                    delay_bits_loaded <= 3'd0;
                    delay_reg <= 4'd0;
                    cycle_counter <= 10'd0;
                    tick_counter <= 4'd0;

                    if (pattern_shift == START_PATTERN)
                        next_state = DELAY_LOAD;
                end

                DELAY_LOAD: begin
                    // Shift delay register left, new bit at LSB to load MSB-first bits
                    delay_reg <= {delay_reg[2:0], data};
                    delay_bits_loaded <= delay_bits_loaded + 1'b1;

                    // Keep other signals off
                    counting <= 1'b0;
                    done <= 1'b0;
                    count <= 4'd0;
                    pattern_shift <= pattern_shift; // hold pattern

                    if (delay_bits_loaded == 3'd3) begin
                        // Next clock we will have loaded 4 bits (counts 0 to 3)
                        next_state = COUNT;

                        // Initialize counters on transition to COUNT
                        // tick_counter = delay + 1
                        tick_counter <= {delay_reg[2:0], data} + 1'b1; 
                        // We include the last bit just shifted in delay_reg[2:0],data
                        // because delay_reg will still have old bits, so reconstruct full 4 bits here
                        cycle_counter <= 10'd0;
                        count <= {delay_reg[2:0], data}; // initial count output (delay)
                    end
                end

                COUNT: begin
                    counting <= 1'b1;
                    done <= 1'b0;

                    // Increment cycle_counter
                    if (cycle_counter == 10'd999) begin
                        cycle_counter <= 10'd0;
                        // Decrement tick_counter if > 0
                        if (tick_counter != 0) begin
                            tick_counter <= tick_counter - 1'b1;
                            count <= tick_counter - 1'b1; // output the next tick count stable for next 1000 cycles
                        end else begin
                            // tick_counter is zero, counting complete
                            // count remains zero stable
                            count <= 4'd0;
                        end
                    end else begin
                        cycle_counter <= cycle_counter + 1'b1;
                        // count remains stable during 1000 cycles per tick
                        count <= count;
                        tick_counter <= tick_counter;
                    end

                    pattern_shift <= pattern_shift; // hold pattern
                    delay_reg <= delay_reg;
                    delay_bits_loaded <= delay_bits_loaded;

                    // Transition to WAIT_ACK only when last cycle of last tick done
                    if ((tick_counter == 0) && (cycle_counter == 10'd999)) begin
                        next_state = WAIT_ACK;
                        counting <= 1'b0;
                        done <= 1'b1;
                        count <= 4'd0;
                    end
                end

                WAIT_ACK: begin
                    done <= 1'b1;
                    counting <= 1'b0;
                    count <= 4'd0;

                    // Hold all registers stable
                    pattern_shift <= pattern_shift;
                    delay_reg <= delay_reg;
                    delay_bits_loaded <= delay_bits_loaded;
                    cycle_counter <= cycle_counter;
                    tick_counter <= tick_counter;

                    if (ack) begin
                        next_state = SEARCH;
                        // On next clock cycle in SEARCH, pattern_shift will reset (below)
                    end
                end

                default: begin
                    // Safety fallback to SEARCH state and reset variables
                    next_state = SEARCH;
                    pattern_shift <= 4'd0;
                    delay_reg <= 4'd0;
                    delay_bits_loaded <= 3'd0;
                    cycle_counter <= 10'd0;
                    tick_counter <= 4'd0;
                    count <= 4'd0;
                    counting <= 1'b0;
                    done <= 1'b0;
                end
            endcase

            // Update state last to avoid glitches in same clock
            state <= next_state;

            // Clear pattern_shift in SEARCH to start fresh after wait_ack + ack
            if (next_state == SEARCH) begin
                pattern_shift <= 4'd0;
                delay_reg <= 4'd0;
                delay_bits_loaded <= 3'd0;
                cycle_counter <= 10'd0;
                tick_counter <= 4'd0;
                count <= 4'd0;
                counting <= 1'b0;
                done <= 1'b0;
            end
        end
    end

endmodule