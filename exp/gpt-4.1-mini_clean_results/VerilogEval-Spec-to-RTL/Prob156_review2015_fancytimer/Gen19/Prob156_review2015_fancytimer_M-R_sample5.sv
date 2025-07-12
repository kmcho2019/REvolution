module TopModule (
    input        clk,
    input        reset,   // synchronous active high
    input        data,
    output reg [3:0] count,
    output reg   counting,
    output reg   done,
    input        ack
);

    // FSM States
    typedef enum reg [2:0] {
        SEARCH     = 3'd0,
        LOAD_DELAY = 3'd1,
        COUNT      = 3'd2,
        DONE       = 3'd3
    } state_t;

    state_t state, next_state;

    // Shift register for detecting start pattern 1101 (MSB first)
    reg [3:0] pattern_shift;

    // Delay register (4 bits)
    reg [3:0] delay_reg;

    // Number of delay bits loaded in LOAD_DELAY
    reg [2:0] delay_bits_cnt;

    // Main down counter counting (delay+1)*1000 cycles
    // Max delay 4'b1111=15, so max count = 16*1000=16000 < 2^15, use 15-bit or more
    // Use 24 bits for safe margin (max 16000 cycles fits in 15 bits)
    reg [23:0] main_counter;

    // Constant for start pattern
    localparam [3:0] START_PATTERN = 4'b1101;

    // Synchronous state and registers update
    always @(posedge clk) begin
        if (reset) begin
            state <= SEARCH;
            pattern_shift <= 4'd0;
            delay_reg <= 4'd0;
            delay_bits_cnt <= 3'd0;
            main_counter <= 24'd0;
            count <= 4'd0;
            counting <= 1'b0;
            done <= 1'b0;
        end else begin
            state <= next_state;

            case (state)
                SEARCH: begin
                    // Shift pattern_shift left by 1, input new bit at LSB
                    pattern_shift <= {pattern_shift[2:0], data};

                    // Clear delay loading and counters
                    delay_reg <= delay_reg;
                    delay_bits_cnt <= 3'd0;
                    main_counter <= 24'd0;

                    // Outputs
                    counting <= 1'b0;
                    done <= 1'b0;
                    count <= 4'd0; // don't care as per spec
                end

                LOAD_DELAY: begin
                    // Shift delay_reg left, input new bit at LSB (MSB first)
                    delay_reg <= {delay_reg[2:0], data};

                    // Increment delay bits loaded
                    delay_bits_cnt <= delay_bits_cnt + 1'b1;

                    // Freeze pattern_shift and counters during delay load
                    pattern_shift <= pattern_shift;
                    main_counter <= 24'd0;

                    // Outputs
                    counting <= 1'b0;
                    done <= 1'b0;
                    count <= 4'd0;
                end

                COUNT: begin
                    // Counting mode, decrement main_counter if not zero
                    if (main_counter != 0)
                        main_counter <= main_counter - 1'b1;
                    else
                        main_counter <= 0;

                    // Freeze pattern_shift and delay_reg during count
                    pattern_shift <= pattern_shift;
                    delay_reg <= delay_reg;
                    delay_bits_cnt <= delay_bits_cnt;

                    // Outputs updated below outside case
                    counting <= 1'b1;
                    done <= 1'b0;
                end

                DONE: begin
                    // Timer finished, wait for ack

                    // Freeze pattern_shift, delay_reg, counters
                    pattern_shift <= pattern_shift;
                    delay_reg <= delay_reg;
                    delay_bits_cnt <= delay_bits_cnt;
                    main_counter <= 24'd0;

                    // Outputs
                    counting <= 1'b0;
                    done <= 1'b1;
                    count <= 4'd0;
                end

                default: begin
                    // Safety fallback to SEARCH
                    state <= SEARCH;
                    pattern_shift <= 4'd0;
                    delay_reg <= 4'd0;
                    delay_bits_cnt <= 3'd0;
                    main_counter <= 24'd0;
                    count <= 4'd0;
                    counting <= 1'b0;
                    done <= 1'b0;
                end
            endcase
        end
    end

    // Next-state combinational logic
    always @(*) begin
        next_state = state;
        case (state)
            SEARCH: begin
                // Detect start pattern
                if (pattern_shift == START_PATTERN)
                    next_state = LOAD_DELAY;
                else
                    next_state = SEARCH;
            end

            LOAD_DELAY: begin
                // After 4 bits loaded, start counting
                if (delay_bits_cnt == 3'd4)
                    next_state = COUNT;
                else
                    next_state = LOAD_DELAY;
            end

            COUNT: begin
                // When main_counter reaches zero, counting done
                if (main_counter == 0)
                    next_state = DONE;
                else
                    next_state = COUNT;
            end

            DONE: begin
                // Wait for ack to restart search
                if (ack)
                    next_state = SEARCH;
                else
                    next_state = DONE;
            end

            default: next_state = SEARCH;
        endcase
    end

    // Update main_counter load at LOAD_DELAY->COUNT transition
    always @(posedge clk) begin
        if (!reset) begin
            // Detect LOAD_DELAY to COUNT rising edge
            if (state == LOAD_DELAY && next_state == COUNT) begin
                // Initialize main_counter = (delay + 1)*1000 - 1 (count down to zero)
                // Cast delay_reg to integer and multiply by 1000
                // For delay=0, counts 1000 cycles (0+1)*1000
                main_counter <= ((delay_reg + 1) * 1000) - 1;
            end
        end
    end

    // Compute count output during COUNT state
    // count shows current "remaining time" in delay ticks, held for 1000 cycles each
    // remaining ticks = integer division of (main_counter+1) by 1000 minus 1 (since we count down)
    // That is:
    // For main_counter = (delay+1)*1000 -1 down to 0:
    // count = (main_counter + 1)/1000 -1
    // clamp to 0 when negative
    always @(*) begin
        if (state == COUNT) begin
            // Compute ticks_remaining = (main_counter + 1)/1000
            // Because main_counter counts down from ((delay+1)*1000 - 1)
            integer ticks_remaining;
            ticks_remaining = (main_counter + 1) / 1000;
            // count output = ticks_remaining -1, clamp at 0
            if (ticks_remaining > 0)
                count = ticks_remaining - 1;
            else
                count = 4'd0;
        end else begin
            // When not counting, count is don't care, assign 0 for convenience
            count = 4'd0;
        end
    end

endmodule