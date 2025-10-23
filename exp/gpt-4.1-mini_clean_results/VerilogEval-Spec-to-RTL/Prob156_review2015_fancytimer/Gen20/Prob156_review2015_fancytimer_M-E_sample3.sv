module TopModule (
    input         clk,
    input         reset, // synchronous active high
    input         data,
    output reg [3:0] count,
    output reg      counting,
    output reg      done,
    input          ack
);

    // FSM states
    typedef enum logic [1:0] {
        SEARCH  = 2'd0,
        LOAD    = 2'd1,
        COUNT   = 2'd2,
        DONE    = 2'd3
    } state_t;

    state_t state, next_state;

    // Shift register for pattern detection (4 bits)
    reg [3:0] pattern_shift;

    // Delay register (4 bits)
    reg [3:0] delay_reg;
    reg [2:0] load_bit_cnt; // counts 0 to 4 bits loaded

    // Counters for timing
    reg [9:0] cycle_cnt;    // 0..999 cycles
    reg [4:0] block_cnt;    // delay+1 blocks, max 17 to cover 4 bits + 1

    // Pattern match signal
    wire pattern_detected = (pattern_shift == 4'b1101);

    // Next state logic
    always_comb begin
        next_state = state;
        case(state)
            SEARCH: if (pattern_detected) next_state = LOAD;
            LOAD: if (load_bit_cnt == 3'd4) next_state = COUNT;
            COUNT: if ((block_cnt == 0) && (cycle_cnt == 10'd999)) next_state = DONE;
            DONE: if (ack) next_state = SEARCH;
            default: next_state = SEARCH;
        endcase
    end

    // Sequential logic: state, pattern shift, delay loading, counting
    always_ff @(posedge clk) begin
        if (reset) begin
            state <= SEARCH;
            pattern_shift <= 4'd0;
            delay_reg <= 4'd0;
            load_bit_cnt <= 3'd0;
            cycle_cnt <= 10'd0;
            block_cnt <= 5'd0;
            count <= 4'd0;
            counting <= 1'b0;
            done <= 1'b0;
        end else begin
            state <= next_state;

            case (state)
                SEARCH: begin
                    // Shift pattern register MSB first:
                    // Shift left, insert new data bit at LSB
                    pattern_shift <= {pattern_shift[2:0], data};

                    delay_reg <= delay_reg;
                    load_bit_cnt <= 3'd0;
                    cycle_cnt <= 10'd0;
                    block_cnt <= 5'd0;

                    counting <= 1'b0;
                    done <= 1'b0;
                    count <= 4'bx; // don't care
                end

                LOAD: begin
                    // Shift delay bits MSB first:
                    // shift left, insert new bit at LSB
                    delay_reg <= {delay_reg[2:0], data};

                    load_bit_cnt <= load_bit_cnt + 1'b1;

                    pattern_shift <= pattern_shift; // hold pattern shift

                    counting <= 1'b0;
                    done <= 1'b0;
                    count <= 4'bx; // don't care
                end

                COUNT: begin
                    pattern_shift <= pattern_shift; // freeze pattern shift
                    load_bit_cnt <= load_bit_cnt;

                    counting <= 1'b1;
                    done <= 1'b0;

                    // On first cycle entering COUNT, initialize counters
                    if (state != COUNT && next_state == COUNT) begin
                        cycle_cnt <= 10'd0;
                        block_cnt <= delay_reg + 1'b1;
                    end else begin
                        // Increment cycle counter
                        if (cycle_cnt == 10'd999) begin
                            cycle_cnt <= 10'd0;
                            if (block_cnt != 0)
                                block_cnt <= block_cnt - 1'b1;
                        end else begin
                            cycle_cnt <= cycle_cnt + 1'b1;
                        end
                    end

                    // Output count as block_cnt - 1 (shows remaining blocks)
                    if (block_cnt == 0)
                        count <= 4'd0;
                    else
                        count <= block_cnt[3:0] - 1'b1;
                end

                DONE: begin
                    pattern_shift <= pattern_shift;
                    delay_reg <= delay_reg;
                    load_bit_cnt <= load_bit_cnt;
                    cycle_cnt <= cycle_cnt;
                    block_cnt <= block_cnt;

                    counting <= 1'b0;
                    done <= 1'b1;
                    count <= 4'bx; // don't care

                    if (ack) begin
                        // Clear to start searching again
                        pattern_shift <= 4'd0;
                        delay_reg <= 4'd0;
                        load_bit_cnt <= 3'd0;
                        cycle_cnt <= 10'd0;
                        block_cnt <= 5'd0;
                        counting <= 1'b0;
                        done <= 1'b0;
                        count <= 4'd0;
                    end
                end

                default: begin
                    state <= SEARCH;
                    pattern_shift <= 4'd0;
                    delay_reg <= 4'd0;
                    load_bit_cnt <= 3'd0;
                    cycle_cnt <= 10'd0;
                    block_cnt <= 5'd0;
                    counting <= 1'b0;
                    done <= 1'b0;
                    count <= 4'd0;
                end
            endcase
        end
    end
endmodule