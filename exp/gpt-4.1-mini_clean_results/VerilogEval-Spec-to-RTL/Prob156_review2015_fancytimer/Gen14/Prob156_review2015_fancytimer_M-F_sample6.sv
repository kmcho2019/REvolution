module TopModule(
    input         clk,
    input         reset,   // synchronous active high
    input         data,
    output reg [3:0] count,
    output reg    counting,
    output reg    done,
    input         ack
);

    // State encoding
    localparam SEARCH     = 2'd0;
    localparam LOAD_DELAY = 2'd1;
    localparam COUNTING   = 2'd2;
    localparam DONE       = 2'd3;

    reg [1:0] state, next_state;

    // Pattern detection shift register (for SEARCH)
    reg [3:0] pattern_shift;

    // Delay bits loading
    reg [3:0] delay;
    reg [2:0] delay_bits_loaded; // counts 0 to 3 in LOAD_DELAY

    // Counters for counting delay cycles
    reg [9:0] cycle_counter; // counts 0 to 999 (1000 cycles)
    reg [3:0] block_counter; // counts how many blocks of 1000 cycles remain

    // Sequential state and registers update
    always @(posedge clk) begin
        if (reset) begin
            state <= SEARCH;
            pattern_shift <= 4'b0;
            delay <= 4'b0;
            delay_bits_loaded <= 3'd0;
            cycle_counter <= 10'd0;
            block_counter <= 4'd0;
            counting <= 1'b0;
            done <= 1'b0;
            count <= 4'd0;
        end else begin
            state <= next_state;

            case(state)
                SEARCH: begin
                    // Shift in data bits for pattern detection
                    pattern_shift <= {pattern_shift[2:0], data};

                    // Clear outputs and counters
                    counting <= 1'b0;
                    done <= 1'b0;
                    count <= 4'd0;
                    delay_bits_loaded <= 3'd0;
                    cycle_counter <= 10'd0;
                    block_counter <= 4'd0;
                    // delay holds previous value (not meaningful here)
                end

                LOAD_DELAY: begin
                    // Shift in delay bits MSB first (4 bits total)
                    delay_bits_loaded <= delay_bits_loaded + 1'b1;
                    delay <= {delay[2:0], data};
                    // outputs still inactive
                    counting <= 1'b0;
                    done <= 1'b0;
                    count <= 4'd0;
                    cycle_counter <= 10'd0;
                    block_counter <= 4'd0;
                    pattern_shift <= pattern_shift; // hold pattern_shift stable
                end

                COUNTING: begin
                    counting <= 1'b1;
                    done <= 1'b0;

                    // Decrement cycle_counter each clock
                    if (cycle_counter == 0) begin
                        // Cycle counter expired, reload to 999 if block_counter not zero
                        if (block_counter != 0) begin
                            cycle_counter <= 10'd999;
                            block_counter <= block_counter - 1'b1;
                        end else begin
                            // Counting done, cycle_counter stays at 0
                            cycle_counter <= 10'd0;
                            block_counter <= 4'd0;
                        end
                    end else begin
                        cycle_counter <= cycle_counter - 1'b1;
                    end

                    // Output count = block_counter - 1 if block_counter>0 else 0
                    // Because for block_counter=N, output count=N-1
                    if (block_counter > 0)
                        count <= block_counter - 1'b1;
                    else
                        count <= 4'd0;

                    // Maintain delay and pattern_shift stable
                    delay <= delay;
                    pattern_shift <= pattern_shift;
                    delay_bits_loaded <= delay_bits_loaded;
                end

                DONE: begin
                    counting <= 1'b0;
                    done <= 1'b1;
                    count <= 4'd0;
                    // Hold all other regs stable
                    pattern_shift <= pattern_shift;
                    delay <= delay;
                    delay_bits_loaded <= 3'd0;
                    cycle_counter <= 10'd0;
                    block_counter <= 4'd0;
                end

                default: begin
                    // Defensive reset to SEARCH
                    state <= SEARCH;
                    pattern_shift <= 4'b0;
                    delay <= 4'b0;
                    delay_bits_loaded <= 3'd0;
                    cycle_counter <= 10'd0;
                    block_counter <= 4'd0;
                    counting <= 1'b0;
                    done <= 1'b0;
                    count <= 4'd0;
                end
            endcase
        end
    end

    // Next state logic
    always @(*) begin
        next_state = state;

        case(state)
            SEARCH: begin
                // If pattern 1101 detected, start loading delay bits
                if (pattern_shift == 4'b1101)
                    next_state = LOAD_DELAY;
            end

            LOAD_DELAY: begin
                // After 4 delay bits loaded, start counting
                if (delay_bits_loaded == 3'd4)
                    next_state = COUNTING;
            end

            COUNTING: begin
                // When done counting (block_counter and cycle_counter zero), go to DONE
                if ((block_counter == 0) && (cycle_counter == 0))
                    next_state = DONE;
            end

            DONE: begin
                // Wait for ack to return to SEARCH
                if (ack)
                    next_state = SEARCH;
            end

            default: next_state = SEARCH;
        endcase
    end

    // Initialize counters after delay loaded: latch delay, setup block and cycle counters
    // This logic runs when LOAD_DELAY finishes (delay_bits_loaded == 4) and state is LOAD_DELAY
    always @(posedge clk) begin
        if (!reset) begin
            if ((state == LOAD_DELAY) && (delay_bits_loaded == 3'd4)) begin
                // delay already latched by shifting bits in delay reg MSB first

                // Initialize block_counter to delay+1, counting how many 1000-cycle blocks to count
                block_counter <= delay + 1'b1;

                // Initialize cycle_counter to 999 for first 1000-cycle block
                cycle_counter <= 10'd999;
            end
        end
    end

endmodule