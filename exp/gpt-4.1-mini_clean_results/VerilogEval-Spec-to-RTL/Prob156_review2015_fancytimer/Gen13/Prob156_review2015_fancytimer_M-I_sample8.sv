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
    localparam SEARCH      = 2'd0;
    localparam LOAD_DELAY  = 2'd1;
    localparam COUNTING    = 2'd2;
    localparam DONE_WAIT   = 2'd3;

    reg [1:0] state, next_state;

    reg [3:0] pattern_shift;
    reg [2:0] load_cnt;
    reg [3:0] delay_reg;

    reg [9:0] cycle_cnt;      // counts 0..999 clock cycles
    reg [4:0] blocks_remain;  // number of 1000-cycle blocks remaining (delay+1)

    // State and registers update
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
                    // Shift pattern to detect '1101'
                    pattern_shift <= {pattern_shift[2:0], data};
                    // Keep outputs inactive
                    counting <= 1'b0;
                    done <= 1'b0;
                    count <= 4'd0;
                    // Clear counters to avoid glitches on start
                    load_cnt <= 3'd0;
                    delay_reg <= 4'd0;
                    cycle_cnt <= 10'd0;
                    blocks_remain <= 5'd0;
                end

                LOAD_DELAY: begin
                    // Shift in delay bits MSB first: shift right, insert data at MSB
                    delay_reg <= {data, delay_reg[3:1]};
                    load_cnt <= load_cnt + 1'b1;
                    // Keep outputs inactive
                    counting <= 1'b0;
                    done <= 1'b0;
                    count <= 4'd0;
                    // cycle_cnt and blocks_remain stay cleared until counting starts
                end

                COUNTING: begin
                    counting <= 1'b1;
                    done <= 1'b0;

                    // cycle count increments and rolls over every 1000 cycles
                    if (cycle_cnt == 10'd999) begin
                        cycle_cnt <= 10'd0;
                        // Decrement blocks_remain only if not zero
                        if (blocks_remain != 0)
                            blocks_remain <= blocks_remain - 1'b1;
                    end else begin
                        cycle_cnt <= cycle_cnt + 1'b1;
                    end

                    // count output is (blocks_remain-1) during counting, or 0 if blocks_remain==0
                    count <= (blocks_remain == 0) ? 4'd0 : (blocks_remain - 1'b1);
                end

                DONE_WAIT: begin
                    done <= 1'b1;
                    counting <= 1'b0;
                    count <= 4'd0;
                    // No change to pattern_shift, load_cnt, delay_reg, cycle_cnt, blocks_remain to avoid toggling
                end
            endcase

            // Load blocks_remain and clear cycle count on transition LOAD_DELAY -> COUNTING
            if (state == LOAD_DELAY && next_state == COUNTING) begin
                blocks_remain <= delay_reg + 1'b1;
                cycle_cnt <= 10'd0;
            end
        end
    end

    // Next state logic combinational
    always @(*) begin
        next_state = state;
        case (state)
            SEARCH: begin
                if (pattern_shift == 4'b1101)
                    next_state = LOAD_DELAY;
            end

            LOAD_DELAY: begin
                if (load_cnt == 3'd4)
                    next_state = COUNTING;
            end

            COUNTING: begin
                // Complete counting after last 1000 cycle block is done
                if (blocks_remain == 0 && cycle_cnt == 10'd999)
                    next_state = DONE_WAIT;
            end

            DONE_WAIT: begin
                if (ack)
                    next_state = SEARCH;
            end
        endcase
    end

endmodule