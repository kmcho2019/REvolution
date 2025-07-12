module TopModule(
    input         clk,
    input         reset, // synchronous active high
    input         data,
    output reg [3:0] count,
    output reg    counting,
    output reg    done,
    input         ack
);

    // FSM states
    localparam SEARCH     = 2'd0;
    localparam LOAD_DELAY = 2'd1;
    localparam COUNTING   = 2'd2;
    localparam DONE_WAIT  = 2'd3;

    reg [1:0] state, next_state;

    // Pattern detection shift register (4 bits)
    reg [3:0] pattern_shift;

    // Delay register (4 bits), delay loaded MSB first
    reg [3:0] delay_reg;
    reg [2:0] load_count; // counts bits loaded in LOAD_DELAY (0 to 4)

    // Counting counters
    reg [9:0] cycle_counter; // counts 0..999 (1000 cycles per tick)
    reg [3:0] tick_counter;  // counts ticks from delay_reg down to 0

    // Sequential state and registers
    always @(posedge clk) begin
        if (reset) begin
            state <= SEARCH;
            pattern_shift <= 4'd0;
            delay_reg <= 4'd0;
            load_count <= 3'd0;
            cycle_counter <= 10'd0;
            tick_counter <= 4'd0;
            counting <= 1'b0;
            done <= 1'b0;
            count <= 4'd0;
        end else begin
            state <= next_state;

            case (state)
                SEARCH: begin
                    counting <= 1'b0;
                    done <= 1'b0;
                    count <= 4'd0;
                    cycle_counter <= 10'd0;
                    tick_counter <= 4'd0;
                    load_count <= 3'd0;
                    delay_reg <= delay_reg; // hold

                    // Shift pattern MSB first: shift left + new bit at LSB
                    pattern_shift <= {pattern_shift[2:0], data};
                end

                LOAD_DELAY: begin
                    counting <= 1'b0;
                    done <= 1'b0;
                    count <= 4'd0;
                    cycle_counter <= 10'd0;
                    tick_counter <= 4'd0;

                    // Shift in delay bits MSB first
                    delay_reg <= {delay_reg[2:0], data};
                    load_count <= load_count + 1'b1;

                    pattern_shift <= pattern_shift; // hold
                end

                COUNTING: begin
                    counting <= 1'b1;
                    done <= 1'b0;

                    if (cycle_counter == 10'd999) begin
                        cycle_counter <= 10'd0;
                        if (tick_counter == 4'd0) begin
                            tick_counter <= 4'd0; // stay at 0
                        end else begin
                            tick_counter <= tick_counter - 1'b1;
                        end
                    end else begin
                        cycle_counter <= cycle_counter + 1'b1;
                    end

                    // Output count = tick_counter (remaining ticks 0..delay)
                    count <= tick_counter;
                end

                DONE_WAIT: begin
                    counting <= 1'b0;
                    done <= 1'b1;
                    count <= 4'd0;
                    cycle_counter <= 10'd0;
                    tick_counter <= 4'd0;
                    load_count <= 3'd0;
                    pattern_shift <= pattern_shift; // hold
                    delay_reg <= delay_reg;         // hold
                end

                default: begin
                    // Defensive defaults
                    state <= SEARCH;
                    counting <= 1'b0;
                    done <= 1'b0;
                    count <= 4'd0;
                    pattern_shift <= 4'd0;
                    delay_reg <= 4'd0;
                    load_count <= 3'd0;
                    cycle_counter <= 10'd0;
                    tick_counter <= 4'd0;
                end
            endcase
        end
    end

    // Next state combinational logic
    always @(*) begin
        next_state = state;

        case (state)
            SEARCH: begin
                // Detect pattern 1101 (MSB first)
                // pattern_shift shifted in MSB first, so if pattern_shift == 4'b1101, found
                if (pattern_shift == 4'b1101)
                    next_state = LOAD_DELAY;
            end

            LOAD_DELAY: begin
                if (load_count == 3'd4)
                    next_state = COUNTING;
            end

            COUNTING: begin
                // Counting done when tick_counter == 0 and cycle_counter == 999 (counted full final tick)
                if ((tick_counter == 4'd0) && (cycle_counter == 10'd999))
                    next_state = DONE_WAIT;
            end

            DONE_WAIT: begin
                if (ack)
                    next_state = SEARCH;
            end

            default: next_state = SEARCH;
        endcase
    end

    // Initialize tick_counter at COUNTING state entry
    // To ensure tick_counter starts at delay_reg and counts down to 0
    // Use a register for previous state to detect rising edge of COUNTING
    reg [1:0] prev_state;
    always @(posedge clk) begin
        if (reset) begin
            prev_state <= SEARCH;
        end else begin
            prev_state <= state;
        end
    end

    always @(posedge clk) begin
        if (!reset) begin
            if (state == COUNTING && prev_state != COUNTING) begin
                // First cycle of COUNTING state, initialize counters
                tick_counter <= delay_reg;
                cycle_counter <= 10'd0;
            end
        end
    end

endmodule