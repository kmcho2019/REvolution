module TopModule (
    input         clk,
    input         reset,  // synchronous active high
    input         data,
    output reg [3:0] count,
    output reg    counting,
    output reg    done,
    input         ack
);

    // FSM states
    typedef enum logic [1:0] {
        PATTERN_DETECT = 2'd0,
        LOAD_DELAY    = 2'd1,
        COUNTING      = 2'd2,
        DONE_STATE    = 2'd3
    } state_t;

    state_t state, next_state;

    // Shift register for pattern detection: 5 bits (to hold last 5 input bits)
    reg [4:0] shift_reg;

    // Delay loading
    reg [2:0] load_bit_cnt; // counts 0..3 bits loaded
    reg [3:0] delay;

    // Counting timers
    localparam integer CYCLES_PER_BLOCK = 1000;
    reg [9:0] cycle_cnt;     // counts 0..999
    reg [4:0] block_cnt;     // counts delay+1 down to 0

    // Detect pattern: lower 4 bits of shift_reg equal 1101 (binary)
    wire pattern_found = (shift_reg[3:0] == 4'b1101);

    // State transitions and combinational next state logic
    always @(*) begin
        next_state = state;
        case(state)
            PATTERN_DETECT: if (pattern_found) next_state = LOAD_DELAY;
            LOAD_DELAY:     if (load_bit_cnt == 3'd4) next_state = COUNTING;
            COUNTING:       if ((block_cnt == 0) && (cycle_cnt == CYCLES_PER_BLOCK-1)) next_state = DONE_STATE;
            DONE_STATE:     if (ack) next_state = PATTERN_DETECT;
            default:        next_state = PATTERN_DETECT;
        endcase
    end

    always @(posedge clk) begin
        if (reset) begin
            state <= PATTERN_DETECT;
            shift_reg <= 5'b0;
            load_bit_cnt <= 3'b0;
            delay <= 4'b0;
            cycle_cnt <= 10'b0;
            block_cnt <= 5'b0;
            count <= 4'b0;
            counting <= 1'b0;
            done <= 1'b0;
        end else begin
            state <= next_state;

            case(state)
                PATTERN_DETECT: begin
                    // Shift in data bit every clock
                    shift_reg <= {shift_reg[3:0], data};
                    // Reset delay loading and counters
                    load_bit_cnt <= 3'b0;
                    delay <= 4'b0;
                    cycle_cnt <= 10'b0;
                    block_cnt <= 5'b0;
                    counting <= 1'b0;
                    done <= 1'b0;
                    count <= 4'b0000; // don't care during idle
                end

                LOAD_DELAY: begin
                    // In LOAD_DELAY, shift in 4 bits MSB first to delay register
                    // Delay bits arrive serially on data input
                    shift_reg <= shift_reg; // no shift during load to freeze pattern detection

                    // Shift in delay bits into delay register MSB first
                    // Shift left and put data at LSB
                    delay <= {delay[2:0], data};

                    load_bit_cnt <= load_bit_cnt + 1'b1;

                    counting <= 1'b0;
                    done <= 1'b0;
                    count <= 4'b0; // don't care during load
                end

                COUNTING: begin
                    shift_reg <= shift_reg; // freeze pattern detection shift register during counting
                    load_bit_cnt <= load_bit_cnt; // no changes
                    delay <= delay; // stable

                    counting <= 1'b1;
                    done <= 1'b0;

                    // cycle counter counts 0..999
                    if (cycle_cnt == CYCLES_PER_BLOCK - 1) begin
                        cycle_cnt <= 10'b0;
                        if (block_cnt != 0)
                            block_cnt <= block_cnt - 1'b1;
                    end else begin
                        cycle_cnt <= cycle_cnt + 1'b1;
                    end

                    // Output count shows remaining blocks minus one during each 1000 cycle block
                    // Because block_cnt counts from delay+1 down to 0, count outputs block_cnt - 1
                    // When block_cnt == 0, counting is ending, count=0.
                    if (block_cnt == 0) begin
                        count <= 4'b0;
                    end else begin
                        count <= block_cnt[3:0] - 1'b1;
                    end
                end

                DONE_STATE: begin
                    shift_reg <= shift_reg; // freeze shift register
                    load_bit_cnt <= load_bit_cnt;
                    delay <= delay;
                    cycle_cnt <= cycle_cnt;
                    block_cnt <= block_cnt;

                    counting <= 1'b0;
                    done <= 1'b1;
                    count <= 4'b0;

                    // When ack asserted, restart pattern detection
                    if (ack) begin
                        // Clear shift register on restart
                        shift_reg <= 5'b0;
                        load_bit_cnt <= 3'b0;
                        delay <= 4'b0;
                        cycle_cnt <= 10'b0;
                        block_cnt <= 5'b0;
                    end
                end

                default: begin
                    state <= PATTERN_DETECT;
                    shift_reg <= 5'b0;
                    load_bit_cnt <= 3'b0;
                    delay <= 4'b0;
                    cycle_cnt <= 10'b0;
                    block_cnt <= 5'b0;
                    count <= 4'b0;
                    counting <= 1'b0;
                    done <= 1'b0;
                end
            endcase

            // On entering COUNTING state from LOAD_DELAY, initialize counters
            if ((state == LOAD_DELAY) && (next_state == COUNTING)) begin
                cycle_cnt <= 10'b0;
                block_cnt <= delay + 1; // delay + 1 blocks of 1000 cycles
            end
        end
    end

endmodule