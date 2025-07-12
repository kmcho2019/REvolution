module TopModule (
    input        clk,
    input        reset,   // synchronous active-high reset
    input        data,
    output reg [3:0] count,
    output reg       counting,
    output reg       done,
    input        ack
);

    // State encoding
    typedef enum logic [1:0] {
        IDLE       = 2'd0,
        DELAY_LOAD = 2'd1,
        COUNTING   = 2'd2,
        DONE       = 2'd3
    } state_t;

    state_t state, next_state;

    // Shift register for pattern detection (4 bits)
    reg [3:0] pattern_shift;

    // Shift register for loading delay bits (4 bits)
    reg [3:0] delay_reg;
    reg [2:0] delay_bits_loaded;  // counts bits loaded: 0 to 4

    // Counters for counting phase
    reg [9:0] cycle_counter;   // Counts 0..999 cycles within a block (10 bits to cover 0-999)
    reg [3:0] block_counter;   // Counts remaining blocks (ticks), from delay down to 0

    // Pattern to detect is 1101 binary
    wire pattern_match = (pattern_shift == 4'b1101);

    // Sequential state register and data path
    always @(posedge clk) begin
        if (reset) begin
            state           <= IDLE;
            pattern_shift   <= 4'b0000;
            delay_reg       <= 4'b0000;
            delay_bits_loaded <= 3'd0;
            cycle_counter   <= 10'd0;
            block_counter   <= 4'd0;
        end else begin
            state <= next_state;

            case (state)
                IDLE: begin
                    // Shift pattern_shift left and append data bit
                    pattern_shift <= {pattern_shift[2:0], data};

                    // Clear delay loading registers
                    delay_reg <= 4'b0000;
                    delay_bits_loaded <= 3'd0;

                    // Clear counters
                    cycle_counter <= 10'd0;
                    block_counter <= 4'd0;
                end

                DELAY_LOAD: begin
                    // Shift delay_reg left, insert new bit LSB (MSB-first loading)
                    delay_reg <= {delay_reg[2:0], data};

                    // Increment bits loaded
                    delay_bits_loaded <= delay_bits_loaded + 1;

                    // pattern_shift held constant (no change)
                    pattern_shift <= pattern_shift;

                    // Clear counters just in case
                    cycle_counter <= 10'd0;
                    block_counter <= 4'd0;
                end

                COUNTING: begin
                    pattern_shift <= pattern_shift; // hold pattern_shift stable

                    // Counting logic: increment cycle_counter every clock
                    if (cycle_counter == 10'd999) begin
                        cycle_counter <= 10'd0;
                        // After finishing a block of 1000 cycles, decrement block_counter if >0
                        if (block_counter != 4'd0)
                            block_counter <= block_counter - 1;
                        else
                            block_counter <= 4'd0; // already zero, hold
                    end else begin
                        cycle_counter <= cycle_counter + 1;
                    end

                    // delay_reg and delay_bits_loaded remain stable
                    delay_reg <= delay_reg;
                    delay_bits_loaded <= delay_bits_loaded;
                end

                DONE: begin
                    // Hold all registers steady until ack is asserted
                    pattern_shift <= pattern_shift;
                    delay_reg <= delay_reg;
                    delay_bits_loaded <= 3'd0;
                    cycle_counter <= 10'd0;
                    block_counter <= 4'd0;
                end

                default: begin
                    // Safe defaults
                    state <= IDLE;
                    pattern_shift <= 4'b0000;
                    delay_reg <= 4'b0000;
                    delay_bits_loaded <= 3'd0;
                    cycle_counter <= 10'd0;
                    block_counter <= 4'd0;
                end
            endcase
        end
    end

    // Next-state combinational logic
    always @(*) begin
        next_state = state;  // default hold state

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
                // Counting done when block_counter = 0 and cycle_counter = 999 (end of last 1000-cycle block)
                if ((block_counter == 4'd0) && (cycle_counter == 10'd999))
                    next_state = DONE;
            end

            DONE: begin
                if (ack)
                    next_state = IDLE;
            end

            default: next_state = IDLE;
        endcase
    end

    // Load block_counter with (delay+1) at the transition DELAY_LOAD -> COUNTING
    // We detect transition by comparing current and next state
    always @(posedge clk) begin
        if (reset) begin
            block_counter <= 4'd0;
        end else begin
            if (state == DELAY_LOAD && next_state == COUNTING) begin
                // Load block_counter with delay + 1 to count exactly (delay+1)*1000 cycles
                block_counter <= delay_reg + 1;
            end
        end
    end

    // Output logic combinational
    always @(*) begin
        counting = 1'b0;
        done = 1'b0;
        count = 4'bxxxx; // don't care default

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

                // The count output is the remaining block count - 1 if cycle_counter > 0, else block_counter.
                // But per problem, count equals the remaining ticks, stable for 1000 cycles each.
                // Because block_counter is decremented right after cycle_counter hits 999,
                // when cycle_counter = 0..998 count is block_counter,
                // when cycle_counter=999 count shows block_counter - 1 (new count value).

                // To avoid glitch, output stable count = block_counter if cycle_counter != 999
                // and block_counter-1 when cycle_counter == 999 (but block_counter not < 0)
                // However, this adds complexity.
                // Instead, simplest and stable approach is output count = block_counter - 1
                // except when block_counter == 0 (count=0).
                // Because the count "remaining ticks" displayed is the current tick being counted.
                // The problem states: count = delay for 1000 cycles, then delay-1 for 1000 cycles,...0 for 1000 cycles.

                // So output count = block_counter - 1;
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