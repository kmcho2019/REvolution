module TopModule (
    input        clk,
    input        reset,   // synchronous active high
    input        data,
    output reg [3:0] count,
    output reg   counting,
    output reg   done,
    input        ack
);

    // States encoding
    localparam IDLE_SEARCH = 3'd0;
    localparam LOAD_DELAY  = 3'd1;
    localparam INIT_COUNT  = 3'd2;
    localparam COUNT       = 3'd3;
    localparam DONE        = 3'd4;

    reg [2:0] state, next_state;

    // Shift register to detect start pattern "1101" (MSB first)
    // Shift left with new bit in LSB on each cycle when in IDLE_SEARCH
    reg [3:0] pattern_shift;

    // Delay register (4 bits) loaded MSB first, by shift left + input at LSB
    reg [3:0] delay_reg;
    reg [2:0] delay_bits_loaded; // 0..4

    // Counters for timing
    reg [9:0] cycle_counter; // 0 to 999 cycles per tick
    reg [3:0] tick_counter;  // delay+1 down to 0

    // Start pattern constant
    localparam [3:0] START_PATTERN = 4'b1101;

    // Sequential logic for state and registers
    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE_SEARCH;
            pattern_shift <= 4'd0;
            delay_reg <= 4'd0;
            delay_bits_loaded <= 3'd0;
            cycle_counter <= 10'd0;
            tick_counter <= 4'd0;
            count <= 4'd0;
            counting <= 1'b0;
            done <= 1'b0;
        end else begin
            state <= next_state;

            case (state)
                IDLE_SEARCH: begin
                    // Shift pattern register only in search state
                    pattern_shift <= {pattern_shift[2:0], data};
                    delay_bits_loaded <= 3'd0;
                    delay_reg <= delay_reg; // hold
                    cycle_counter <= 10'd0;
                    tick_counter <= 4'd0;
                    count <= 4'd0;
                    counting <= 1'b0;
                    done <= 1'b0;
                end

                LOAD_DELAY: begin
                    // Shift delay_reg MSB-first: shift left, input bit at LSB
                    delay_reg <= {delay_reg[2:0], data};
                    delay_bits_loaded <= delay_bits_loaded + 1'b1;
                    // pattern_shift not used here
                    pattern_shift <= pattern_shift;
                    cycle_counter <= 10'd0;
                    tick_counter <= 4'd0;
                    count <= 4'd0;
                    counting <= 1'b0;
                    done <= 1'b0;
                end

                INIT_COUNT: begin
                    // Initialize counters for counting phase
                    tick_counter <= delay_reg + 1'b1; // delay + 1 ticks
                    cycle_counter <= 10'd0;
                    count <= delay_reg; // initial count output is delay (one less than tick_counter)
                    counting <= 1'b1;
                    done <= 1'b0;
                    // Freeze pattern_shift and delay_bits_loaded
                    pattern_shift <= pattern_shift;
                    delay_bits_loaded <= delay_bits_loaded;
                    delay_reg <= delay_reg;
                end

                COUNT: begin
                    counting <= 1'b1;
                    done <= 1'b0;

                    if (cycle_counter == 10'd999) begin
                        cycle_counter <= 10'd0;

                        // Decrement tick_counter if not zero
                        if (tick_counter != 0)
                            tick_counter <= tick_counter - 1'b1;
                        else
                            tick_counter <= 4'd0; // hold at zero
                    end else begin
                        cycle_counter <= cycle_counter + 1'b1;
                        tick_counter <= tick_counter; // hold
                    end

                    // count output is tick_counter - 1, except when tick_counter is 0, output 0
                    if (tick_counter > 0)
                        count <= tick_counter - 1'b1;
                    else
                        count <= 4'd0;

                    // Freeze shift registers
                    pattern_shift <= pattern_shift;
                    delay_reg <= delay_reg;
                    delay_bits_loaded <= delay_bits_loaded;
                end

                DONE: begin
                    done <= 1'b1;
                    counting <= 1'b0;
                    count <= 4'd0;
                    // Freeze all registers
                    pattern_shift <= pattern_shift;
                    delay_reg <= delay_reg;
                    delay_bits_loaded <= delay_bits_loaded;
                    cycle_counter <= 10'd0;
                    tick_counter <= 4'd0;
                end

                default: begin
                    // Default to IDLE_SEARCH safe state
                    state <= IDLE_SEARCH;
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
        end
    end

    // Combinational next-state logic
    always @(*) begin
        next_state = state;
        case (state)
            IDLE_SEARCH: begin
                // Transition to LOAD_DELAY when pattern detected
                if (pattern_shift == START_PATTERN)
                    next_state = LOAD_DELAY;
                else
                    next_state = IDLE_SEARCH;
            end

            LOAD_DELAY: begin
                // After loading 4 delay bits, move to INIT_COUNT
                if (delay_bits_loaded == 3'd4)
                    next_state = INIT_COUNT;
                else
                    next_state = LOAD_DELAY;
            end

            INIT_COUNT: begin
                // Single cycle to initialize counters, then go to COUNT
                next_state = COUNT;
            end

            COUNT: begin
                // When counting done, tick_counter=0 and cycle_counter=999 means all cycles completed
                if ((tick_counter == 0) && (cycle_counter == 10'd999))
                    next_state = DONE;
                else
                    next_state = COUNT;
            end

            DONE: begin
                // Wait for ack to return to IDLE_SEARCH
                if (ack)
                    next_state = IDLE_SEARCH;
                else
                    next_state = DONE;
            end

            default: next_state = IDLE_SEARCH;
        endcase
    end

endmodule