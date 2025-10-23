module TopModule(
    input        clk,
    input        reset, // synchronous active high
    input        data,
    output reg [3:0] count,
    output reg   counting,
    output reg   done,
    input        ack
);

    // FSM states
    typedef enum reg [1:0] {
        SEARCH      = 2'd0,
        LOAD_DELAY  = 2'd1,
        COUNTING    = 2'd2,
        DONE_WAIT   = 2'd3
    } state_t;

    state_t state, next_state;

    reg [3:0] pattern_shift;
    reg [2:0] load_cnt;
    reg [3:0] delay_reg;

    reg [9:0] cycle_cnt;      // counts 0..999 cycles
    reg [4:0] blocks_remain;  // delay+1 blocks remaining, max 17 fits in 5 bits

    always @(posedge clk) begin
        if (reset) begin
            state <= SEARCH;
            pattern_shift <= 4'd0;
            load_cnt <= 3'd0;
            delay_reg <= 4'd0;
            cycle_cnt <= 10'd0;
            blocks_remain <= 5'd0;
            count <= 4'd0;
            counting <= 1'b0;
            done <= 1'b0;
        end else begin
            state <= next_state;

            case (state)
                SEARCH: begin
                    // Shift in input bit to pattern_shift (MSB oldest)
                    pattern_shift <= {pattern_shift[2:0], data};
                    load_cnt <= 0;
                    delay_reg <= 0;
                    cycle_cnt <= 0;
                    blocks_remain <= 0;
                    count <= 0;
                    counting <= 1'b0;
                    done <= 1'b0;
                end

                LOAD_DELAY: begin
                    // Shift in delay bits MSB first: insert data at MSB, shift right
                    delay_reg <= {data, delay_reg[3:1]};
                    load_cnt <= load_cnt + 1'b1;
                    pattern_shift <= pattern_shift;
                    cycle_cnt <= 0;
                    blocks_remain <= 0;
                    counting <= 1'b0;
                    done <= 1'b0;
                    count <= 0;
                end

                COUNTING: begin
                    pattern_shift <= pattern_shift;
                    load_cnt <= load_cnt;
                    delay_reg <= delay_reg;
                    counting <= 1'b1;
                    done <= 1'b0;

                    if (cycle_cnt == 10'd999) begin
                        cycle_cnt <= 10'd0;
                        if (blocks_remain != 0)
                            blocks_remain <= blocks_remain - 1'b1;
                    end else begin
                        cycle_cnt <= cycle_cnt + 1'b1;
                    end

                    // count output = current blocks_remain except during last cycle block where it decreases
                    // Show count as blocks_remain - 1 during 0..998 cycles, blocks_remain at cycle_cnt==999
                    if (blocks_remain == 0) begin
                        count <= 4'd0;
                    end else if (cycle_cnt == 10'd999) begin
                        count <= blocks_remain[3:0];
                    end else begin
                        count <= (blocks_remain - 1'b1)[3:0];
                    end
                end

                DONE_WAIT: begin
                    pattern_shift <= pattern_shift;
                    load_cnt <= load_cnt;
                    delay_reg <= delay_reg;
                    cycle_cnt <= 0;
                    blocks_remain <= 0;
                    counting <= 1'b0;
                    done <= 1'b1;
                    count <= 0;
                end
            endcase

            // Load blocks_remain = delay + 1 when entering COUNTING from LOAD_DELAY
            if (state == LOAD_DELAY && next_state == COUNTING) begin
                blocks_remain <= delay_reg + 1'b1;
                cycle_cnt <= 0;
            end
        end
    end

    always @(*) begin
        next_state = state;
        case (state)
            SEARCH: if (pattern_shift == 4'b1101) next_state = LOAD_DELAY;
            LOAD_DELAY: if (load_cnt == 3'd4) next_state = COUNTING;
            COUNTING: if ((blocks_remain == 0) && (cycle_cnt == 10'd999)) next_state = DONE_WAIT;
            DONE_WAIT: if (ack) next_state = SEARCH;
        endcase
    end

endmodule