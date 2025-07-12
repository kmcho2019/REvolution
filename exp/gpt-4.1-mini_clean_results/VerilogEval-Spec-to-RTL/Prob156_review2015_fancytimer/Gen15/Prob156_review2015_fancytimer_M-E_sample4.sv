module TopModule (
    input        clk,
    input        reset,    // synchronous active high
    input        data,
    output reg [3:0] count,
    output reg   counting,
    output reg   done,
    input        ack
);

    // States for main FSM
    typedef enum reg [1:0] {
        PATTERN_DETECT = 2'b00,
        LOAD_DELAY     = 2'b01,
        COUNTING       = 2'b10,
        DONE_STATE     = 2'b11
    } state_t;

    state_t state, next_state;

    // Pattern Detector - 4-bit shift register
    reg [3:0] pattern_shift;

    // Signals to indicate pattern detected rising edge
    wire pattern_match = (pattern_shift == 4'b1101);

    // Delay shift register and bit count for loading delay bits
    reg [3:0] delay_shift;
    reg [2:0] delay_bit_cnt;  // counts 0 to 3

    // Loaded delay value
    reg [3:0] delay_value;

    // Counting logic:
    // Total count cycles = (delay+1)*1000
    // 1000 = 0x3E8 cycles
    localparam integer CYCLES_PER_BLOCK = 1000;

    reg [13:0] cycle_counter;   // max (16*1000=16000) fits in 14 bits

    // Block counter is upper nibble of count down timer:
    // count output is remaining blocks (delay down to 0)
    // cycle_counter counts total cycles left

    // Extract current block and cycle within block from cycle_counter:
    // block_count = cycle_counter / 1000 (integer division)
    // cycle_in_block = cycle_counter % 1000

    // Instead of division, we do:
    // decrement cycle_counter each cycle
    // count output = cycle_counter / 1000 (integer division)

    // Implement division by 1000 via simple subtraction:
    // To avoid complexity, just count blocks and cycles separately.

    reg [3:0] block_count;      // counts from delay down to 0
    reg [9:0] subcycle_count;   // counts from 999 down to 0

    // State machine sequential logic
    always @(posedge clk) begin
        if (reset) begin
            state <= PATTERN_DETECT;
            pattern_shift <= 4'b0000;
            delay_shift <= 4'd0;
            delay_bit_cnt <= 3'd0;
            delay_value <= 4'd0;
            cycle_counter <= 14'd0;
            block_count <= 4'd0;
            subcycle_count <= 10'd0;
            count <= 4'd0;
            counting <= 1'b0;
            done <= 1'b0;
        end else begin
            state <= next_state;

            case(state)
                PATTERN_DETECT: begin
                    counting <= 1'b0;
                    done <= 1'b0;
                    count <= 4'bxxxx;  // don't care

                    // Shift pattern register in data
                    pattern_shift <= {pattern_shift[2:0], data};

                    // Clear delay loading registers
                    delay_shift <= 4'd0;
                    delay_bit_cnt <= 3'd0;
                end

                LOAD_DELAY: begin
                    counting <= 1'b0;
                    done <= 1'b0;
                    count <= 4'bxxxx; // don't care during load

                    // Shift in delay bits MSB first
                    delay_shift <= {delay_shift[2:0], data};
                    delay_bit_cnt <= delay_bit_cnt + 1'b1;

                    // After 4 bits loaded, latch delay_value
                    if (delay_bit_cnt == 3'd3) begin
                        delay_value <= {delay_shift[2:0], data};
                    end
                end

                COUNTING: begin
                    counting <= 1'b1;
                    done <= 1'b0;

                    if (subcycle_count == 0) begin
                        if (block_count != 0) begin
                            block_count <= block_count - 1'b1;
                            subcycle_count <= CYCLES_PER_BLOCK - 1;
                        end else begin
                            // Counting finished, stay at zero
                            subcycle_count <= 0;
                        end
                    end else begin
                        subcycle_count <= subcycle_count - 1'b1;
                    end

                    // Output remaining blocks as count, stable for 1000 cycles
                    count <= block_count;
                end

                DONE_STATE: begin
                    counting <= 1'b0;
                    done <= 1'b1;
                    count <= 4'bxxxx; // don't care in done

                    // Keep registers stable until ack clears done
                end

                default: begin
                    // Should never happen, default safe state
                    state <= PATTERN_DETECT;
                    pattern_shift <= 4'b0000;
                    delay_shift <= 4'd0;
                    delay_bit_cnt <= 3'd0;
                    delay_value <= 4'd0;
                    cycle_counter <= 14'd0;
                    block_count <= 4'd0;
                    subcycle_count <= 10'd0;
                    count <= 4'd0;
                    counting <= 1'b0;
                    done <= 1'b0;
                end
            endcase
        end
    end

    // Next state logic combinational
    always @(*) begin
        next_state = state;

        case(state)
            PATTERN_DETECT: begin
                if (pattern_match)
                    next_state = LOAD_DELAY;
            end

            LOAD_DELAY: begin
                if (delay_bit_cnt == 3'd4)
                    next_state = COUNTING;
            end

            COUNTING: begin
                if ((block_count == 0) && (subcycle_count == 0))
                    next_state = DONE_STATE;
            end

            DONE_STATE: begin
                if (ack)
                    next_state = PATTERN_DETECT;
            end

            default: next_state = PATTERN_DETECT;
        endcase
    end

    // Initialize counters at LOAD_DELAY->COUNTING transition (one-cycle pulse)
    reg start_counting_pulse;

    always @(posedge clk) begin
        if (reset) begin
            start_counting_pulse <= 1'b0;
        end else begin
            // Generate start_counting_pulse at LOAD_DELAY done (bit_cnt=4)
            start_counting_pulse <= (state == LOAD_DELAY) && (delay_bit_cnt == 3'd4);
        end
    end

    always @(posedge clk) begin
        if (reset) begin
            block_count <= 4'd0;
            subcycle_count <= 10'd0;
        end else if (start_counting_pulse) begin
            // Initialize block_count = delay_value (MSB first already correct)
            // Actually delay is count down from delay to 0 for count output
            // But counting phase counts (delay+1)*1000 cycles, so block_count = delay_value
            block_count <= delay_value;
            subcycle_count <= CYCLES_PER_BLOCK - 1;  // start subcycle count from 999 down to 0
        end
    end

endmodule