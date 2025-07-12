module TopModule (
    input        clk,
    input        reset,   // synchronous active-high reset
    input        data,
    output reg [3:0] count,
    output reg       counting,
    output reg       done,
    input        ack
);

    // State encoding using localparam
    localparam IDLE       = 2'd0;
    localparam DELAY_LOAD = 2'd1;
    localparam COUNTING   = 2'd2;
    localparam DONE       = 2'd3;

    reg [1:0] state, next_state;

    // Pattern detection shift register (4 bits)
    reg [3:0] pattern_shift;

    // Delay loading shift register and bit counter (3 bits to count 0..4)
    reg [3:0] delay_reg;
    reg [2:0] delay_bits_loaded;

    // Counters for counting phase
    reg [9:0] cycle_counter;   // counts 0..999 cycles per block (10 bits)
    reg [3:0] block_counter;   // counts remaining blocks (delay+1 down to 0)

    // Pattern match for 1101
    wire pattern_match = (pattern_shift == 4'b1101);

    // Sequential logic: state, pattern shift, delay loading, counters
    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            pattern_shift <= 4'b0;
            delay_reg <= 4'b0;
            delay_bits_loaded <= 3'd0;
            cycle_counter <= 10'd0;
            block_counter <= 4'd0;
        end else begin
            state <= next_state;

            case (state)
                IDLE: begin
                    // Shift in data bit for pattern detection (left shift, new bit at LSB)
                    pattern_shift <= {pattern_shift[2:0], data};
                    delay_reg <= 4'b0;
                    delay_bits_loaded <= 3'd0;
                    cycle_counter <= 10'd0;
                    block_counter <= 4'd0;
                end

                DELAY_LOAD: begin
                    // Shift delay_reg left, MSB first (shift left, new bit into LSB)
                    delay_reg <= {delay_reg[2:0], data};
                    delay_bits_loaded <= delay_bits_loaded + 1'b1;
                    // pattern_shift held constant during delay load
                    pattern_shift <= pattern_shift;
                    cycle_counter <= 10'd0;
                    block_counter <= 4'd0;
                end

                COUNTING: begin
                    // Hold pattern and delay registers stable
                    pattern_shift <= pattern_shift;

                    delay_reg <= delay_reg;
                    delay_bits_loaded <= delay_bits_loaded;

                    // Cycle counter increments
                    if (cycle_counter == 10'd999) begin
                        cycle_counter <= 10'd0;
                        // Decrement block_counter at rollover if not zero
                        if (block_counter != 0)
                            block_counter <= block_counter - 1;
                        else
                            block_counter <= 0;
                    end else begin
                        cycle_counter <= cycle_counter + 1;
                        // block_counter holds steady during the 1000 cycles
                        block_counter <= block_counter;
                    end
                end

                DONE: begin
                    // Hold all registers steady until ack resets the FSM
                    pattern_shift <= pattern_shift;
                    delay_reg <= delay_reg;
                    delay_bits_loaded <= 3'd0;
                    cycle_counter <= 10'd0;
                    block_counter <= 4'd0;
                end

                default: begin
                    // Default safe reset to IDLE
                    state <= IDLE;
                    pattern_shift <= 4'b0;
                    delay_reg <= 4'b0;
                    delay_bits_loaded <= 3'd0;
                    cycle_counter <= 10'd0;
                    block_counter <= 4'd0;
                end
            endcase
        end
    end

    // Next-state logic
    always @(*) begin
        next_state = state;
        case (state)
            IDLE: begin
                if (pattern_match)
                    next_state = DELAY_LOAD;
            end

            DELAY_LOAD: begin
                if (delay_bits_loaded == 4)
                    next_state = COUNTING;
            end

            COUNTING: begin
                // When block_counter == 0 and cycle_counter == 999 (end of last block), go to DONE
                if ((block_counter == 0) && (cycle_counter == 10'd999))
                    next_state = DONE;
            end

            DONE: begin
                if (ack)
                    next_state = IDLE;
            end
        endcase
    end

    // Load block_counter with delay+1 at DELAY_LOAD->COUNTING transition
    reg delay_load_strobe; // strobe signal for loading block_counter

    always @(posedge clk) begin
        if (reset) begin
            block_counter <= 4'd0;
            delay_load_strobe <= 1'b0;
        end else begin
            delay_load_strobe <= 1'b0; // default no strobe

            // Detect DELAY_LOAD->COUNTING transition
            if ((state == DELAY_LOAD) && (next_state == COUNTING)) begin
                block_counter <= delay_reg + 1;
                delay_load_strobe <= 1'b1;
            end
        end
    end

    // Output logic (registered)
    always @(*) begin
        counting = 1'b0;
        done = 1'b0;
        count = 4'bxxxx; // default don't-care

        case (state)
            IDLE: begin
                counting = 1'b0;
                done = 1'b0;
                count = 4'bxxxx; // don't care
            end

            DELAY_LOAD: begin
                counting = 1'b0;
                done = 1'b0;
                count = 4'bxxxx; // don't care
            end

            COUNTING: begin
                counting = 1'b1;
                done = 1'b0;
                // count output reflects remaining blocks minus 1 (the current tick being counted)
                // because block_counter counts down after each 1000 cycle block completes
                if (block_counter == 0)
                    count = 4'd0;
                else
                    count = block_counter - 1;
            end

            DONE: begin
                counting = 1'b0;
                done = 1'b1;
                count = 4'bxxxx; // don't care
            end

            default: begin
                counting = 1'b0;
                done = 1'b0;
                count = 4'bxxxx;
            end
        endcase
    end

endmodule