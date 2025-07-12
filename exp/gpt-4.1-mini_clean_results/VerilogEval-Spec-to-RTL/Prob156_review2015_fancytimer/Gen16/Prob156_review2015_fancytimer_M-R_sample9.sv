module TopModule (
    input         clk,
    input         reset,   // synchronous active high
    input         data,
    output reg [3:0] count,
    output reg    counting,
    output reg    done,
    input         ack
);

    // FSM states
    localparam [1:0]
        SEARCH     = 2'd0,
        DELAY_LOAD = 2'd1,
        COUNT      = 2'd2,
        WAIT_ACK   = 2'd3;

    reg [1:0] state, next_state;

    // Shift register for detecting start pattern 1101 (MSB-first)
    reg [3:0] pattern_shift;

    // Delay register: 4 bits delay (MSB-first)
    reg [3:0] delay_reg;
    reg [2:0] delay_bits_loaded;  // count bits loaded (0..4)

    // Counters for counting cycles and ticks
    reg [9:0] cycle_counter;  // counts 0..999 cycles per tick
    reg [4:0] tick_counter;   // counts ticks remaining (delay+1)

    // next_state combinational logic
    always @(*) begin
        next_state = state;
        case(state)
            SEARCH: begin
                // If pattern detected, go to load delay bits
                if (pattern_shift == 4'b1101)
                    next_state = DELAY_LOAD;
            end
            DELAY_LOAD: begin
                // After loading 4 delay bits, start counting
                if (delay_bits_loaded == 3'd4)
                    next_state = COUNT;
            end
            COUNT: begin
                // When counting finishes (tick_counter == 0 and end of 1000 cycles)
                if ((tick_counter == 0) && (cycle_counter == 10'd999))
                    next_state = WAIT_ACK;
            end
            WAIT_ACK: begin
                // Wait for ack to restart
                if (ack)
                    next_state = SEARCH;
            end
        endcase
    end

    // Sequential logic: registers update
    always @(posedge clk) begin
        if (reset) begin
            // Reset all registers and outputs
            state <= SEARCH;
            pattern_shift <= 4'b0000;
            delay_reg <= 4'b0000;
            delay_bits_loaded <= 3'd0;
            cycle_counter <= 10'd0;
            tick_counter <= 5'd0;
            counting <= 1'b0;
            done <= 1'b0;
            count <= 4'b0000;
        end else begin
            state <= next_state;

            case(state)
                SEARCH: begin
                    counting <= 1'b0;
                    done <= 1'b0;
                    count <= 4'b0000;
                    cycle_counter <= 10'd0;
                    tick_counter <= 5'd0;
                    delay_bits_loaded <= 3'd0;
                    delay_reg <= delay_reg; // hold until delay load

                    // Shift in data bit for pattern detection, MSB first
                    // Shift left, insert new bit at LSB
                    pattern_shift <= {pattern_shift[2:0], data};
                end

                DELAY_LOAD: begin
                    counting <= 1'b0;
                    done <= 1'b0;
                    count <= 4'b0000;
                    cycle_counter <= 10'd0;
                    tick_counter <= 5'd0;

                    // Shift in delay bits MSB-first: shift left, insert data at LSB
                    delay_reg <= {delay_reg[2:0], data};
                    delay_bits_loaded <= delay_bits_loaded + 1'b1;

                    // Do not update pattern_shift in this state
                    pattern_shift <= pattern_shift;
                end

                COUNT: begin
                    counting <= 1'b1;
                    done <= 1'b0;

                    // Freeze pattern and delay registers
                    pattern_shift <= pattern_shift;
                    delay_reg <= delay_reg;
                    delay_bits_loaded <= delay_bits_loaded;

                    // cycle_counter counts 0..999
                    if (cycle_counter == 10'd999) begin
                        cycle_counter <= 10'd0;
                        if (tick_counter != 0) begin
                            tick_counter <= tick_counter - 1'b1;
                            // Update count output after decrementing tick_counter
                            // Output the current count as tick_counter-1 (which is previous tick_counter)
                            if (tick_counter > 1)
                                count <= tick_counter - 1'b1;
                            else
                                count <= 4'd0;
                        end else begin
                            // Counting done, count output 0
                            count <= 4'd0;
                        end
                    end else begin
                        cycle_counter <= cycle_counter + 1'b1;
                        // count stable between tick updates
                        count <= count;
                        tick_counter <= tick_counter;
                    end
                end

                WAIT_ACK: begin
                    counting <= 1'b0;
                    done <= 1'b1;

                    // Clear pattern and delay registers for next cycle after ack
                    pattern_shift <= 4'b0000;
                    delay_reg <= 4'b0000;
                    delay_bits_loaded <= 3'd0;
                    cycle_counter <= 10'd0;
                    tick_counter <= 5'd0;
                    count <= 4'b0000;
                end

                default: begin
                    // Default safe reset
                    state <= SEARCH;
                    pattern_shift <= 4'b0000;
                    delay_reg <= 4'b0000;
                    delay_bits_loaded <= 3'd0;
                    cycle_counter <= 10'd0;
                    tick_counter <= 5'd0;
                    counting <= 1'b0;
                    done <= 1'b0;
                    count <= 4'b0000;
                end
            endcase

            // Initialize tick_counter and count when entering COUNT state
            if ((state == DELAY_LOAD) && (next_state == COUNT)) begin
                tick_counter <= {1'b0, delay_reg} + 5'd1; // delay + 1 ticks
                cycle_counter <= 10'd0;
                count <= delay_reg; // initial count output corresponds to delay value
            end
        end
    end

endmodule