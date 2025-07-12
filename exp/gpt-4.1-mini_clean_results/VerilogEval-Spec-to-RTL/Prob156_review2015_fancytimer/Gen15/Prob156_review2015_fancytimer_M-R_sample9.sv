module TopModule(
    input        clk,
    input        reset,  // synchronous active high
    input        data,
    output reg [3:0] count,
    output reg   counting,
    output reg   done,
    input        ack
);

    // State declarations
    typedef enum logic [1:0] {
        SEARCH      = 2'b00,
        LOAD_DELAY  = 2'b01,
        COUNTING    = 2'b10,
        DONE_WAIT   = 2'b11
    } state_t;

    state_t state, next_state;

    // Pattern detection: 4-bit shift register storing last 4 data bits, MSB first
    reg [3:0] pattern_shift;

    // Delay load registers
    reg [3:0] delay_reg;
    reg [2:0] load_count; // counts 0..4 bits loaded

    // Counting registers
    reg [3:0] tick_count;  // counts down from delay_reg to 0 inclusive
    reg [9:0] cycle_count; // counts 0..999 (1000 cycles per tick)

    // Next state logic: combinational
    always @(*) begin
        next_state = state;
        case(state)
            SEARCH: begin
                if (pattern_shift == 4'b1101)
                    next_state = LOAD_DELAY;
            end

            LOAD_DELAY: begin
                if (load_count == 3'd4)
                    next_state = COUNTING;
            end

            COUNTING: begin
                // Finish counting after last tick and last cycle
                if (tick_count == 4'd0 && cycle_count == 10'd999)
                    next_state = DONE_WAIT;
            end

            DONE_WAIT: begin
                if (ack)
                    next_state = SEARCH;
            end

            default: next_state = SEARCH;
        endcase
    end

    // Sequential logic: state, registers, counters
    always @(posedge clk) begin
        if (reset) begin
            state        <= SEARCH;
            pattern_shift <= 4'b0000;
            delay_reg    <= 4'd0;
            load_count   <= 3'd0;
            tick_count   <= 4'd0;
            cycle_count  <= 10'd0;
            counting     <= 1'b0;
            done         <= 1'b0;
            count        <= 4'b0000;
        end else begin
            state <= next_state;

            case (state)
                SEARCH: begin
                    // Shift in data MSB first: left shift, data at LSB
                    pattern_shift <= {pattern_shift[2:0], data};

                    // Reset delay and counters
                    delay_reg   <= 4'd0;
                    load_count  <= 3'd0;
                    tick_count  <= 4'd0;
                    cycle_count <= 10'd0;
                    counting   <= 1'b0;
                    done       <= 1'b0;
                    count      <= 4'bxxxx; // don't care outside counting
                end

                LOAD_DELAY: begin
                    // Shift in delay bits MSB first, data at LSB
                    delay_reg <= {delay_reg[2:0], data};
                    load_count <= load_count + 1;

                    // Keep pattern_shift unchanged (ignore during load)
                    pattern_shift <= pattern_shift;

                    counting <= 1'b0;
                    done <= 1'b0;
                    count <= 4'bxxxx;
                    tick_count <= 4'd0;
                    cycle_count <= 10'd0;
                end

                COUNTING: begin
                    counting <= 1'b1;
                    done <= 1'b0;

                    // Initialize tick_count and cycle_count on first clock in COUNTING
                    if (state != next_state) begin
                        // just entered COUNTING
                        tick_count <= delay_reg;
                        cycle_count <= 10'd0;
                        // count output updated below
                    end else begin
                        // Counting logic
                        if (cycle_count == 10'd999) begin
                            cycle_count <= 10'd0;
                            if (tick_count != 4'd0)
                                tick_count <= tick_count - 1;
                            // else tick_count remains 0 for last 1000 cycles
                        end else begin
                            cycle_count <= cycle_count + 1;
                        end
                    end

                    // Output count is current tick_count, stable for 1000 cycles
                    count <= tick_count;
                end

                DONE_WAIT: begin
                    counting <= 1'b0;
                    done <= 1'b1;

                    // Clear counters and count outputs don't care
                    count <= 4'bxxxx;
                    tick_count <= 4'd0;
                    cycle_count <= 10'd0;
                    load_count <= 3'd0;

                    // pattern_shift not updated during DONE_WAIT
                    pattern_shift <= pattern_shift;
                    delay_reg <= delay_reg;
                end

                default: begin
                    // safe defaults
                    state        <= SEARCH;
                    pattern_shift <= 4'b0000;
                    delay_reg    <= 4'd0;
                    load_count   <= 3'd0;
                    tick_count   <= 4'd0;
                    cycle_count  <= 10'd0;
                    counting     <= 1'b0;
                    done         <= 1'b0;
                    count        <= 4'b0000;
                end
            endcase
        end
    end

endmodule