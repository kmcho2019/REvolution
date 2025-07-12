module TopModule (
    input        clk,
    input        reset,  // synchronous active-high reset
    input        data,
    output reg [3:0] count,
    output reg       counting,
    output reg       done,
    input        ack
);

    // State encoding (2-bit)
    localparam IDLE       = 2'd0;
    localparam LOAD_DELAY = 2'd1;
    localparam COUNTING   = 2'd2;
    localparam DONE       = 2'd3;

    reg [1:0] state, next_state;

    // Pattern detection shift register
    reg [3:0] pattern_shift;

    // Delay register and bit counter
    reg [3:0] delay_reg;
    reg [2:0] delay_bit_count;

    // Counters for timing
    reg [11:0] cycle_counter;  // counts 0..999 cycles for one tick
    reg [3:0] tick_counter;    // counts from delay down to 0, inclusive

    wire pattern_detected = (pattern_shift == 4'b1101);

    // Next state logic combinational
    always @(*) begin
        case(state)
            IDLE: begin
                if (pattern_detected)
                    next_state = LOAD_DELAY;
                else
                    next_state = IDLE;
            end

            LOAD_DELAY: begin
                if (delay_bit_count == 4)
                    next_state = COUNTING;
                else
                    next_state = LOAD_DELAY;
            end

            COUNTING: begin
                // When cycle_counter and tick_counter both zero after decrementing means done counting
                if (tick_counter == 0 && cycle_counter == 12'd999)
                    next_state = DONE;
                else
                    next_state = COUNTING;
            end

            DONE: begin
                if (ack)
                    next_state = IDLE;
                else
                    next_state = DONE;
            end

            default: next_state = IDLE;
        endcase
    end

    // Sequential logic
    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            pattern_shift <= 4'b0000;
            delay_reg <= 4'b0000;
            delay_bit_count <= 3'd0;
            cycle_counter <= 12'd0;
            tick_counter <= 4'd0;
        end else begin
            state <= next_state;

            case(state)
                IDLE: begin
                    // Shift in pattern bits to detect start pattern
                    pattern_shift <= {pattern_shift[2:0], data};

                    // Clear delay and counters
                    delay_reg <= 4'b0000;
                    delay_bit_count <= 3'd0;
                    cycle_counter <= 12'd0;
                    tick_counter <= 4'd0;
                end

                LOAD_DELAY: begin
                    // Shift delay bits MSB first: shift left, insert data at LSB
                    delay_reg <= {delay_reg[2:0], data};
                    delay_bit_count <= delay_bit_count + 1;

                    // Freeze pattern_shift during delay loading
                    pattern_shift <= pattern_shift;

                    // Clear counters
                    cycle_counter <= 12'd0;
                    tick_counter <= 4'd0;
                end

                COUNTING: begin
                    // Freeze pattern_shift during counting
                    pattern_shift <= pattern_shift;

                    if (cycle_counter == 12'd999) begin
                        cycle_counter <= 12'd0;
                        if (tick_counter > 0)
                            tick_counter <= tick_counter - 1;
                    end else begin
                        cycle_counter <= cycle_counter + 1;
                    end

                    // delay_reg and delay_bit_count remain unchanged
                end

                DONE: begin
                    // Freeze pattern_shift during done
                    pattern_shift <= pattern_shift;

                    // Clear delay and counters remain cleared
                    delay_reg <= delay_reg;
                    delay_bit_count <= 3'd0;
                    cycle_counter <= 12'd0;
                    tick_counter <= 4'd0;
                end

                default: begin
                    // Safety: reset all
                    pattern_shift <= 4'b0000;
                    delay_reg <= 4'b0000;
                    delay_bit_count <= 3'd0;
                    cycle_counter <= 12'd0;
                    tick_counter <= 4'd0;
                end
            endcase

            // Load tick_counter with delay at transition LOAD_DELAY -> COUNTING
            if (state == LOAD_DELAY && next_state == COUNTING) begin
                tick_counter <= delay_reg; // Load with delay, counting down to zero inclusive
                cycle_counter <= 12'd0;
            end
        end
    end

    // Output logic combinational
    always @(*) begin
        // Default outputs
        counting = 1'b0;
        done = 1'b0;
        count = 4'bxxxx; // don't care outside counting if desired

        case(state)
            IDLE: begin
                counting = 1'b0;
                done = 1'b0;
                count = 4'bxxxx;
            end

            LOAD_DELAY: begin
                counting = 1'b0;
                done = 1'b0;
                count = 4'bxxxx;
            end

            COUNTING: begin
                counting = 1'b1;
                done = 1'b0;
                // Output count equals tick_counter, stable for 1000 cycles each
                count = tick_counter;
            end

            DONE: begin
                counting = 1'b0;
                done = 1'b1;
                count = 4'bxxxx;
            end

            default: begin
                counting = 1'b0;
                done = 1'b0;
                count = 4'bxxxx;
            end
        endcase
    end

endmodule