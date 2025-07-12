module TopModule(
    input        clk,
    input        reset,  // synchronous active high
    input        data,
    output reg [3:0] count,
    output reg   counting,
    output reg   done,
    input        ack
);

    // FSM states
    localparam IDLE       = 2'd0;
    localparam LOAD_DELAY = 2'd1;
    localparam COUNTING   = 2'd2;
    localparam DONE       = 2'd3;

    reg [1:0] state, next_state;

    // Shift register to detect pattern 1101 in IDLE
    // Shift left: pattern_shift <= {pattern_shift[2:0], data};
    // When pattern_shift == 4'b1101 => pattern detected
    reg [3:0] pattern_shift;

    // Delay shift register and bit counter during LOAD_DELAY
    reg [3:0] delay_reg;
    reg [2:0] delay_bits_loaded;  // 0 to 4 bits loaded

    // Counting registers
    reg [9:0] cycle_count;         // counts 0..999
    reg [4:0] blocks_remaining;    // counts down (delay+1) blocks max 17

    // FSM sequential logic
    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            pattern_shift <= 4'd0;
            delay_reg <= 4'd0;
            delay_bits_loaded <= 3'd0;
            cycle_count <= 10'd0;
            blocks_remaining <= 5'd0;
            count <= 4'd0;
            counting <= 1'b0;
            done <= 1'b0;
        end else begin
            state <= next_state;

            case(state)
                IDLE: begin
                    done <= 1'b0;
                    counting <= 1'b0;

                    // Shift in data for pattern detection
                    pattern_shift <= {pattern_shift[2:0], data};

                    // Clear delay loading and counters
                    delay_reg <= 4'd0;
                    delay_bits_loaded <= 3'd0;
                    cycle_count <= 10'd0;
                    blocks_remaining <= 5'd0;

                    count <= 4'd0;  // not counting, hold 0
                end

                LOAD_DELAY: begin
                    done <= 1'b0;
                    counting <= 1'b0;

                    // Shift delay bits MSB first: shift left, insert new bit at LSB
                    delay_reg <= {delay_reg[2:0], data};
                    delay_bits_loaded <= delay_bits_loaded + 1'b1;

                    pattern_shift <= pattern_shift; // hold pattern_shift steady
                    cycle_count <= 10'd0;
                    blocks_remaining <= 5'd0;

                    count <= 4'd0; // not counting
                end

                COUNTING: begin
                    done <= 1'b0;
                    counting <= 1'b1;

                    pattern_shift <= pattern_shift;
                    delay_reg <= delay_reg;
                    delay_bits_loaded <= delay_bits_loaded;

                    // Count cycles within current 1000-cycle block
                    if (cycle_count == 10'd999) begin
                        cycle_count <= 10'd0;
                        if (blocks_remaining > 0) begin
                            blocks_remaining <= blocks_remaining - 1'b1;
                        end
                    end else begin
                        cycle_count <= cycle_count + 1'b1;
                    end

                    // count output = blocks_remaining - 1 (safe because blocks_remaining>=0)
                    if (blocks_remaining > 0)
                        count <= blocks_remaining - 1'b1;
                    else
                        count <= 4'd0;
                end

                DONE: begin
                    done <= 1'b1;
                    counting <= 1'b0;

                    pattern_shift <= pattern_shift;
                    delay_reg <= delay_reg;
                    delay_bits_loaded <= delay_bits_loaded;
                    cycle_count <= 10'd0;
                    blocks_remaining <= 5'd0;

                    count <= 4'd0; // done state, count=0
                end

                default: begin
                    // Should never get here
                    state <= IDLE;
                    pattern_shift <= 4'd0;
                    delay_reg <= 4'd0;
                    delay_bits_loaded <= 3'd0;
                    cycle_count <= 10'd0;
                    blocks_remaining <= 5'd0;
                    count <= 4'd0;
                    counting <= 1'b0;
                    done <= 1'b0;
                end
            endcase
        end
    end

    // FSM combinational next state logic
    always @(*) begin
        next_state = state;

        case(state)
            IDLE: begin
                // Detect pattern 1101
                if (pattern_shift == 4'b1101)
                    next_state = LOAD_DELAY;
            end

            LOAD_DELAY: begin
                if (delay_bits_loaded == 3'd4)
                    next_state = COUNTING;
            end

            COUNTING: begin
                // When blocks_remaining == 0 and cycle_count == 999 (end of last block), go DONE
                if ((blocks_remaining == 0) && (cycle_count == 10'd999))
                    next_state = DONE;
            end

            DONE: begin
                // Wait for ack to return to IDLE
                if (ack)
                    next_state = IDLE;
            end

            default: next_state = IDLE;
        endcase
    end

    // Initialization on transition to COUNTING state
    // Set blocks_remaining = delay_reg + 1; reset cycle_count=0
    reg state_prev_LOAD_DELAY;
    always @(posedge clk) begin
        if (reset) begin
            state_prev_LOAD_DELAY <= 1'b0;
        end else begin
            state_prev_LOAD_DELAY <= (state == LOAD_DELAY);
        end
    end

    wire start_counting = (state_prev_LOAD_DELAY) && (next_state == COUNTING);

    always @(posedge clk) begin
        if (!reset && start_counting) begin
            blocks_remaining <= delay_reg + 1'b1;
            cycle_count <= 10'd0;
            // count output will be updated in COUNTING state logic
        end
    end

endmodule