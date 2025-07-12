module TopModule (
    input         clk,
    input         reset,  // synchronous active-high reset
    input         data,
    output reg [3:0] count,
    output reg    counting,
    output reg    done,
    input         ack
);

    // State encoding
    typedef enum reg [1:0] {
        SEARCH     = 2'b00,
        LOAD_DELAY = 2'b01,
        COUNTING   = 2'b10,
        DONE       = 2'b11
    } state_t;

    state_t state, next_state;

    // Shift register for pattern detection
    reg [3:0] pattern_shift;

    // Delay bits register and load counter (count how many delay bits received)
    reg [3:0] delay_reg;
    reg [2:0] delay_bit_count; // counts from 0 to 3

    // Cycle and tick counters
    reg [9:0] cycle_counter;  // counts 0..999
    reg [3:0] tick_counter;   // counts down from delay to 0

    // Pattern match signal
    wire pattern_match = (pattern_shift == 4'b1101);

    // Next state logic combinational
    always @(*) begin
        next_state = state; // default hold

        case (state)
            SEARCH: begin
                if (pattern_match)
                    next_state = LOAD_DELAY;
            end

            LOAD_DELAY: begin
                if (delay_bit_count == 3'd4) // 4 bits loaded
                    next_state = COUNTING;
            end

            COUNTING: begin
                if (tick_counter == 0 && cycle_counter == 10'd999)
                    next_state = DONE;
            end

            DONE: begin
                if (ack)
                    next_state = SEARCH;
            end
        endcase
    end

    // Sequential logic
    always @(posedge clk) begin
        if (reset) begin
            // Initialize all registers and outputs
            state <= SEARCH;

            pattern_shift <= 4'd0;

            delay_reg <= 4'd0;
            delay_bit_count <= 3'd0;

            cycle_counter <= 10'd0;
            tick_counter <= 4'd0;

            count <= 4'd0;
            counting <= 1'b0;
            done <= 1'b0;
        end else begin
            state <= next_state;

            case (state)
                SEARCH: begin
                    // Shift in serial data for pattern detection: shift left, new data at LSB
                    pattern_shift <= {pattern_shift[2:0], data};

                    // Reset delay loading registers and counters
                    delay_reg <= 4'd0;
                    delay_bit_count <= 3'd0;

                    cycle_counter <= 10'd0;
                    tick_counter <= 4'd0;

                    count <= 4'd0;
                    counting <= 1'b0;
                    done <= 1'b0;
                end

                LOAD_DELAY: begin
                    // pattern_shift stays unchanged here (not needed further)

                    // Shift in delay bits MSB first: shift left, new bit at LSB
                    delay_reg <= {delay_reg[2:0], data};

                    // Increment bit count on each bit loaded
                    delay_bit_count <= delay_bit_count + 1'b1;

                    cycle_counter <= 10'd0;
                    tick_counter <= 4'd0;

                    count <= 4'd0;
                    counting <= 1'b0;
                    done <= 1'b0;
                end

                COUNTING: begin
                    pattern_shift <= pattern_shift; // hold

                    delay_reg <= delay_reg;         // hold
                    delay_bit_count <= 3'd0;        // not used in counting

                    // Increment cycle counter each clock
                    if (cycle_counter == 10'd999) begin
                        cycle_counter <= 10'd0;

                        // Decrement tick_counter only when 1000 cycles have elapsed
                        if (tick_counter != 0)
                            tick_counter <= tick_counter - 1'b1;
                        else
                            tick_counter <= 4'd0; // remain at zero when done
                    end else begin
                        cycle_counter <= cycle_counter + 1'b1;
                        tick_counter <= tick_counter;
                    end

                    // Initialize tick_counter on first cycle of COUNTING state
                    // Because state changes synchronously, detect transition to COUNTING
                    if (state != COUNTING && next_state == COUNTING) begin
                        tick_counter <= delay_reg;
                        cycle_counter <= 10'd0;
                    end

                    counting <= 1'b1;
                    done <= 1'b0;

                    // Update count output to current tick_counter (remaining ticks)
                    count <= tick_counter;
                end

                DONE: begin
                    // Hold all except outputs to signal done
                    pattern_shift <= 4'd0;
                    delay_reg <= 4'd0;
                    delay_bit_count <= 3'd0;
                    cycle_counter <= 10'd0;
                    tick_counter <= 4'd0;

                    count <= 4'd0;
                    counting <= 1'b0;
                    done <= 1'b1;
                end
            endcase
        end
    end

endmodule