module TopModule (
    input           clk,
    input           reset,  // synchronous active high
    input           data,
    output reg [3:0] count,
    output reg      counting,
    output reg      done,
    input           ack
);

    // FSM states
    typedef enum logic [1:0] {
        PATTERN_DETECT = 2'd0,
        LOAD_DELAY     = 2'd1,
        COUNTING       = 2'd2,
        DONE_STATE     = 2'd3
    } state_t;

    state_t state, next_state;
    state_t prev_state; // to detect state transitions

    // Pattern detection shift register (4 bits)
    reg [3:0] pattern_shift;

    // Delay loading
    reg [2:0] load_bit_cnt; // counts 0..3
    reg [3:0] delay_reg;

    // Counting timers
    localparam int CYCLES_PER_BLOCK = 1000;
    reg [9:0] cycle_cnt;   // 0..999
    reg [4:0] block_cnt;   // counts delay+1 down to 0

    // Pattern detect signal
    wire pattern_found = (pattern_shift == 4'b1101);

    // Next state logic
    always_comb begin
        next_state = state;
        case(state)
            PATTERN_DETECT: 
                if (pattern_found)
                    next_state = LOAD_DELAY;
            LOAD_DELAY:
                if (load_bit_cnt == 3'd4)
                    next_state = COUNTING;
            COUNTING:
                if ((block_cnt == 0) && (cycle_cnt == CYCLES_PER_BLOCK - 1))
                    next_state = DONE_STATE;
            DONE_STATE:
                if (ack)
                    next_state = PATTERN_DETECT;
        endcase
    end

    // Sequential logic
    always_ff @(posedge clk) begin
        if (reset) begin
            state <= PATTERN_DETECT;
            prev_state <= PATTERN_DETECT;
            pattern_shift <= 4'b0000;
            load_bit_cnt <= 3'd0;
            delay_reg <= 4'd0;
            cycle_cnt <= 10'd0;
            block_cnt <= 5'd0;
            count <= 4'd0;
            counting <= 1'b0;
            done <= 1'b0;
        end else begin
            prev_state <= state;
            state <= next_state;

            case(state)
                PATTERN_DETECT: begin
                    // Shift in data MSB first: shift left and put new bit at LSB
                    pattern_shift <= {pattern_shift[2:0], data};

                    // Reset loading and counters
                    load_bit_cnt <= 3'd0;
                    delay_reg <= 4'd0;
                    cycle_cnt <= 10'd0;
                    block_cnt <= 5'd0;

                    counting <= 1'b0;
                    done <= 1'b0;

                    count <= 4'bxxxx; // don't care when not counting
                end

                LOAD_DELAY: begin
                    // No shifting pattern_shift, freeze it

                    // Shift in delay bits MSB first: shift left and input new bit at LSB
                    if (load_bit_cnt < 3'd4) begin
                        delay_reg <= {delay_reg[2:0], data};
                        load_bit_cnt <= load_bit_cnt + 1'b1;
                    end

                    counting <= 1'b0;
                    done <= 1'b0;

                    count <= 4'bxxxx; // don't care during loading
                end

                COUNTING: begin
                    // Freeze pattern_shift and load_bit_cnt
                    pattern_shift <= pattern_shift;
                    load_bit_cnt <= load_bit_cnt;

                    counting <= 1'b1;
                    done <= 1'b0;

                    // Initialize counters once when entering COUNTING state
                    if (prev_state != COUNTING) begin
                        cycle_cnt <= 10'd0;
                        block_cnt <= delay_reg + 1'b1;
                    end else begin
                        // Count clock cycles 0..999
                        if (cycle_cnt == CYCLES_PER_BLOCK - 1) begin
                            cycle_cnt <= 10'd0;
                            if (block_cnt != 0)
                                block_cnt <= block_cnt - 1'b1;
                        end else begin
                            cycle_cnt <= cycle_cnt + 1'b1;
                        end
                    end

                    // count output: show remaining block count minus one or zero if none
                    if (block_cnt == 0)
                        count <= 4'd0;
                    else
                        count <= block_cnt[3:0] - 1'b1;
                end

                DONE_STATE: begin
                    // Freeze all registers except control signals
                    pattern_shift <= pattern_shift;
                    load_bit_cnt <= load_bit_cnt;
                    delay_reg <= delay_reg;
                    cycle_cnt <= cycle_cnt;
                    block_cnt <= block_cnt;

                    counting <= 1'b0;
                    done <= 1'b1;

                    count <= 4'bxxxx; // don't care in done

                    if (ack) begin
                        // Reset for new detection
                        pattern_shift <= 4'b0000;
                        load_bit_cnt <= 3'd0;
                        delay_reg <= 4'd0;
                        cycle_cnt <= 10'd0;
                        block_cnt <= 5'd0;
                        done <= 1'b0;
                    end
                end
            endcase
        end
    end

endmodule