module TopModule(
    input        clk,
    input        reset,    // synchronous active high
    input        data,
    output reg [3:0] count,
    output reg   counting,
    output reg   done,
    input        ack
);

    // FSM States
    typedef enum reg [1:0] {
        SEARCH     = 2'd0,
        LOAD_DELAY = 2'd1,
        COUNTING   = 2'd2,
        DONE_WAIT  = 2'd3
    } state_t;
    reg [1:0] state, next_state;

    // Shift register for pattern detection
    reg [3:0] pattern_shift;

    // Delay loading
    reg [1:0] load_bit_index;  // Counts 0 to 3 bits loaded
    reg [3:0] delay_reg;       // Loaded delay bits

    // Counting timers
    reg [9:0] cycle_subcount;  // Counts 0..999 clock cycles within each 1000-cycle block
    reg [4:0] blocks_remaining; // Delay+1 timer blocks remaining (5 bits to hold max 17)

    // Sequential logic: state transitions, counters, outputs
    always @(posedge clk) begin
        if (reset) begin
            state <= SEARCH;
            pattern_shift <= 4'b0000;
            load_bit_index <= 2'd0;
            delay_reg <= 4'd0;
            cycle_subcount <= 10'd0;
            blocks_remaining <= 5'd0;
            counting <= 1'b0;
            done <= 1'b0;
            count <= 4'b0000;
        end else begin
            state <= next_state;

            case(state)
                SEARCH: begin
                    // Shift in the data bit (MSB oldest)
                    pattern_shift <= {pattern_shift[2:0], data};

                    // Clear delay loading registers
                    load_bit_index <= 2'd0;
                    delay_reg <= 4'd0;

                    // Clear counting registers
                    cycle_subcount <= 10'd0;
                    blocks_remaining <= 5'd0;

                    // Outputs
                    counting <= 1'b0;
                    done <= 1'b0;
                    count <= 4'b0000;
                end

                LOAD_DELAY: begin
                    // Shift in delay bits MSB first (shift left and insert LSB = data)
                    delay_reg <= {delay_reg[2:0], data};

                    load_bit_index <= load_bit_index + 1'b1;

                    // Outputs during loading
                    counting <= 1'b0;
                    done <= 1'b0;
                    count <= 4'b0000;

                    // pattern_shift unchanged
                    pattern_shift <= pattern_shift;

                    // Clear counters, not yet counting
                    cycle_subcount <= 10'd0;
                    blocks_remaining <= 5'd0;
                end

                COUNTING: begin
                    counting <= 1'b1;
                    done <= 1'b0;

                    // Increment cycle_subcount each clock cycle
                    if (cycle_subcount == 10'd999) begin
                        cycle_subcount <= 10'd0;
                        // Decrement blocks_remaining (timer blocks)
                        if (blocks_remaining > 0)
                            blocks_remaining <= blocks_remaining - 1'b1;
                    end else begin
                        cycle_subcount <= cycle_subcount + 1'b1;
                    end

                    // Output the current remaining count (blocks_remaining - 1)
                    // Because blocks_remaining counts how many blocks are left including current
                    // So for delay=0 (1 block), it starts at 1, outputs 0 during counting
                    if (blocks_remaining > 0)
                        count <= blocks_remaining - 1;
                    else
                        count <= 4'd0;

                    // pattern_shift unchanged during counting
                    pattern_shift <= pattern_shift;
                    load_bit_index <= load_bit_index;
                    delay_reg <= delay_reg;
                end

                DONE_WAIT: begin
                    counting <= 1'b0;
                    done <= 1'b1;

                    // count don't care, set 0
                    count <= 4'd0;

                    // Hold registers
                    pattern_shift <= pattern_shift;
                    load_bit_index <= load_bit_index;
                    delay_reg <= delay_reg;
                    cycle_subcount <= 10'd0;
                    blocks_remaining <= 5'd0;
                end

                default: begin
                    // default fallback to SEARCH on unexpected state
                    state <= SEARCH;
                    pattern_shift <= 4'b0000;
                    load_bit_index <= 2'd0;
                    delay_reg <= 4'd0;
                    cycle_subcount <= 10'd0;
                    blocks_remaining <= 5'd0;
                    counting <= 1'b0;
                    done <= 1'b0;
                    count <= 4'd0;
                end
            endcase
        end
    end

    // Next state logic combinational
    always @(*) begin
        next_state = state;
        case(state)
            SEARCH: begin
                // Check if pattern_shift matches 1101 to start loading delay
                if (pattern_shift == 4'b1101) begin
                    next_state = LOAD_DELAY;
                end
            end

            LOAD_DELAY: begin
                if (load_bit_index == 2'd4) begin
                    // Once 4 bits loaded, go to COUNTING
                    next_state = COUNTING;
                end
            end

            COUNTING: begin
                // Done when all blocks counted and last cycle_subcount finished
                if ((blocks_remaining == 5'd0) && (cycle_subcount == 10'd999)) begin
                    next_state = DONE_WAIT;
                end
            end

            DONE_WAIT: begin
                if (ack) begin
                    next_state = SEARCH;
                end
            end

            default: next_state = SEARCH;
        endcase
    end

    // Load blocks_remaining = delay + 1 at LOAD_DELAY end
    always @(posedge clk) begin
        if (reset) begin
            blocks_remaining <= 5'd0;
        end else begin
            // At the clock where load_bit_index reaches 4 (delay fully loaded)
            // and state is LOAD_DELAY (i.e. transition to COUNTING next),
            // initialize blocks_remaining with delay + 1
            if ((state == LOAD_DELAY) && (load_bit_index == 2'd4)) begin
                blocks_remaining <= {1'b0, delay_reg} + 1'b1; // zero-extend delay_reg to 5 bits +1
            end
        end
    end

endmodule