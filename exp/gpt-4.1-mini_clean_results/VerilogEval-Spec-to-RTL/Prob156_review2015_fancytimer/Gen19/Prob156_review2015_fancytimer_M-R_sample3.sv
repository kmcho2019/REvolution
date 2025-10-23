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

    // Pattern detection shift register (4 bits)
    reg [3:0] pattern_shift;

    // Delay loading
    reg [2:0] load_bit_cnt;
    reg [3:0] delay_reg;

    // Counting timers
    localparam int CYCLES_PER_BLOCK = 1000;
    reg [9:0] cycle_cnt;   // 0..999
    reg [4:0] block_cnt;   // counts delay+1 down to 0 (max 17 to cover 4 bits +1)

    // Pattern detect signal
    wire pattern_found = (pattern_shift == 4'b1101);

    // Next state logic
    always_comb begin
        next_state = state;
        case(state)
            PATTERN_DETECT: 
                if (pattern_found) next_state = LOAD_DELAY;
            LOAD_DELAY:
                if (load_bit_cnt == 3'd4) next_state = COUNTING;
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
            pattern_shift <= 4'b0000;
            load_bit_cnt <= 3'd0;
            delay_reg <= 4'd0;
            cycle_cnt <= 10'd0;
            block_cnt <= 5'd0;
            count <= 4'd0;
            counting <= 1'b0;
            done <= 1'b0;
        end else begin
            state <= next_state;

            case(state)
                PATTERN_DETECT: begin
                    // Shift in data bit, LSB is newest bit
                    pattern_shift <= {pattern_shift[2:0], data};

                    // Clear delay load and counters
                    load_bit_cnt <= 3'd0;
                    delay_reg <= 4'd0;
                    cycle_cnt <= 10'd0;
                    block_cnt <= 5'd0;

                    counting <= 1'b0;
                    done <= 1'b0;

                    count <= 4'bx; // don't care when not counting
                end

                LOAD_DELAY: begin
                    // Freeze pattern_shift (no shifting)

                    // Shift delay bits MSB first: shift delay_reg left, insert data at LSB
                    delay_reg <= {delay_reg[2:0], data};

                    load_bit_cnt <= load_bit_cnt + 1'b1;

                    counting <= 1'b0;
                    done <= 1'b0;
                    count <= 4'bx; // don't care during loading
                end

                COUNTING: begin
                    // Freeze pattern_shift
                    pattern_shift <= pattern_shift;

                    load_bit_cnt <= load_bit_cnt;

                    counting <= 1'b1;
                    done <= 1'b0;

                    // On first cycle of COUNTING state, initialize counters
                    // Detect state transition entering COUNTING:
                    if (state != COUNTING && next_state == COUNTING) begin
                        cycle_cnt <= 10'd0;
                        block_cnt <= delay_reg + 1'b1;
                    end else begin
                        if (cycle_cnt == CYCLES_PER_BLOCK - 1) begin
                            cycle_cnt <= 10'd0;
                            if (block_cnt != 0)
                                block_cnt <= block_cnt - 1'b1;
                        end else begin
                            cycle_cnt <= cycle_cnt + 1'b1;
                        end
                    end

                    // Output count: remaining blocks minus 1, or 0 if block_cnt==0
                    if (block_cnt == 0)
                        count <= 4'd0;
                    else
                        count <= block_cnt[3:0] - 1'b1;
                end

                DONE_STATE: begin
                    // Freeze pattern_shift
                    pattern_shift <= pattern_shift;

                    load_bit_cnt <= load_bit_cnt;
                    delay_reg <= delay_reg;
                    cycle_cnt <= cycle_cnt;
                    block_cnt <= block_cnt;

                    counting <= 1'b0;
                    done <= 1'b1;

                    count <= 4'bx; // don't care

                    if (ack) begin
                        // Prepare for new detection after ack
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