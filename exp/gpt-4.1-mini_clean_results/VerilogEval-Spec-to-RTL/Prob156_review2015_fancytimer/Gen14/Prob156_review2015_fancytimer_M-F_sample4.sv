module TopModule (
    input         clk,
    input         reset,   // synchronous active high
    input         data,
    output reg [3:0] count,
    output reg    counting,
    output reg    done,
    input         ack
);

    // FSM States
    typedef enum logic [1:0] {
        SEARCH     = 2'd0,
        DELAY_LOAD = 2'd1,
        COUNT      = 2'd2,
        WAIT_ACK   = 2'd3
    } state_t;

    state_t state, next_state;

    // Pattern detection shift register (4 bits)
    // Shift right, insert new data bit at MSB for MSB-first input stream
    reg [3:0] pattern_shift;

    // Delay register - load 4 bits MSB first by shifting left and inserting data at LSB
    reg [3:0] delay_reg;
    reg [2:0] delay_bits_loaded;  // counts 0 to 4

    // Cycle counter: counts 0..999 cycles per tick
    reg [9:0] cycle_counter;

    // Tick counter: counts remaining ticks down from delay+1 to 0
    reg [4:0] tick_counter;

    // Register to hold stable current count output during 1000 cycle interval
    reg [3:0] current_count;

    // State machine and counters synchronous update
    always @(posedge clk) begin
        if (reset) begin
            state <= SEARCH;

            pattern_shift <= 4'd0;
            delay_reg <= 4'd0;
            delay_bits_loaded <= 3'd0;

            cycle_counter <= 10'd0;
            tick_counter <= 5'd0;

            counting <= 1'b0;
            done <= 1'b0;
            count <= 4'd0;
            current_count <= 4'd0;
        end else begin
            state <= next_state;

            case (state)
                SEARCH: begin
                    // Shift pattern_shift right by 1 and insert data at MSB (MSB-first)
                    pattern_shift <= {data, pattern_shift[3:1]};

                    // Clear delay-related registers on entry to SEARCH
                    if (next_state == SEARCH) begin
                        delay_reg <= delay_reg;
                        delay_bits_loaded <= 3'd0;
                    end else begin
                        delay_reg <= delay_reg;
                        delay_bits_loaded <= delay_bits_loaded;
                    end

                    counting <= 1'b0;
                    done <= 1'b0;
                    count <= 4'd0;
                    current_count <= 4'd0;

                    cycle_counter <= 10'd0;
                    tick_counter <= 5'd0;
                end

                DELAY_LOAD: begin
                    // Shift in delay bits MSB-first: shift left, insert data at LSB
                    delay_reg <= {delay_reg[2:0], data};
                    delay_bits_loaded <= delay_bits_loaded + 1'b1;

                    // Clear other signals
                    counting <= 1'b0;
                    done <= 1'b0;
                    count <= 4'd0;
                    current_count <= 4'd0;

                    cycle_counter <= 10'd0;
                    tick_counter <= 5'd0;

                    pattern_shift <= pattern_shift;
                end

                COUNT: begin
                    counting <= 1'b1;
                    done <= 1'b0;

                    pattern_shift <= pattern_shift;
                    delay_reg <= delay_reg;
                    delay_bits_loaded <= delay_bits_loaded;

                    // Increment cycle_counter until 999
                    if (cycle_counter == 10'd999) begin
                        cycle_counter <= 10'd0;

                        // On cycle_counter wrap, decrement tick_counter if >0
                        if (tick_counter != 5'd0) begin
                            tick_counter <= tick_counter - 1'b1;
                            // Update current_count for next 1000 cycle interval
                            if (tick_counter > 5'd1) begin
                                current_count <= tick_counter[3:0] - 1'b1;
                            end else begin
                                current_count <= 4'd0;
                            end
                        end else begin
                            // tick_counter == 0, counting done - keep current_count at 0
                            tick_counter <= 5'd0;
                            current_count <= 4'd0;
                        end
                    end else begin
                        cycle_counter <= cycle_counter + 1'b1;
                        // Maintain current_count stable during 1000 cycles
                        current_count <= current_count;
                        tick_counter <= tick_counter;
                    end

                    count <= current_count;
                end

                WAIT_ACK: begin
                    counting <= 1'b0;
                    done <= 1'b1;

                    count <= 4'd0;
                    current_count <= 4'd0;

                    pattern_shift <= 4'd0;
                    delay_reg <= 4'd0;
                    delay_bits_loaded <= 3'd0;

                    cycle_counter <= 10'd0;
                    tick_counter <= 5'd0;
                end

                default: begin
                    // Should not happen
                    state <= SEARCH;
                    pattern_shift <= 4'd0;
                    delay_reg <= 4'd0;
                    delay_bits_loaded <= 3'd0;

                    cycle_counter <= 10'd0;
                    tick_counter <= 5'd0;

                    counting <= 1'b0;
                    done <= 1'b0;
                    count <= 4'd0;
                    current_count <= 4'd0;
                end
            endcase
        end
    end

    // Next state combinational logic
    always @(*) begin
        next_state = state;

        case(state)
            SEARCH: begin
                // Detect pattern 1101 in pattern_shift after shifting in new bit (MSB first)
                // pattern_shift[3:0], pattern bits shifted right with new MSB bit
                // Check if pattern_shift equals 4'b1101 (binary)
                // i.e. bits = 1 1 0 1 with pattern_shift[3] = first bit received most recently
                if (pattern_shift == 4'b1101)
                    next_state = DELAY_LOAD;
                else
                    next_state = SEARCH;
            end

            DELAY_LOAD: begin
                if (delay_bits_loaded == 3'd4)
                    next_state = COUNT;
                else
                    next_state = DELAY_LOAD;
            end

            COUNT: begin
                // Finish counting when tick_counter == 0 and cycle_counter == 999 (end of last tick)
                if ((tick_counter == 5'd0) && (cycle_counter == 10'd999))
                    next_state = WAIT_ACK;
                else
                    next_state = COUNT;
            end

            WAIT_ACK: begin
                if (ack)
                    next_state = SEARCH;
                else
                    next_state = WAIT_ACK;
            end

            default: next_state = SEARCH;
        endcase
    end

    // Initialize tick_counter, cycle_counter, current_count on transition DELAY_LOAD->COUNT
    // Use a registered previous state to detect transition
    reg [1:0] prev_state;
    always @(posedge clk) begin
        if (reset) begin
            prev_state <= SEARCH;
        end else begin
            prev_state <= state;
        end
    end

    always @(posedge clk) begin
        if (reset) begin
            tick_counter <= 5'd0;
            cycle_counter <= 10'd0;
            current_count <= 4'd0;
        end else begin
            if ((prev_state == DELAY_LOAD) && (state == COUNT)) begin
                // Initialize tick_counter = delay_reg + 1
                tick_counter <= {1'b0, delay_reg} + 5'd1;
                cycle_counter <= 10'd0;

                // current_count initialized to delay (tick_counter - 1)
                current_count <= delay_reg;
            end
        end
    end

endmodule