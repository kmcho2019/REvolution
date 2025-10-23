module TopModule(
    input         clk,
    input         reset, // synchronous active high
    input         data,
    output reg [3:0] count,
    output reg    counting,
    output reg    done,
    input         ack
);

    // FSM states encoded as 2 bits
    localparam SEARCH      = 2'd0;
    localparam LOAD_DELAY  = 2'd1;
    localparam COUNTING    = 2'd2;
    localparam DONE_WAIT   = 2'd3;

    reg [1:0] state, next_state;

    reg [3:0] pattern_shift;   // shift register for detecting start pattern and for delay input
    reg [2:0] load_cnt;        // counts bits loaded in LOAD_DELAY state (0 to 4)
    reg [3:0] delay_reg;       // stores the delay value (MSB first)

    reg [9:0] cycle_cnt;       // counts clock cycles in each 1000-cycle block (0-999)
    reg [4:0] blocks_remain;   // counts (delay + 1) blocks down to zero

    // FSM and datapath sequential logic
    always @(posedge clk) begin
        if (reset) begin
            // Reset all registers and outputs
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
                    // Shift in data for pattern detection
                    pattern_shift <= {pattern_shift[2:0], data};
                    load_cnt <= 3'd0;
                    delay_reg <= 4'd0;
                    cycle_cnt <= 10'd0;
                    blocks_remain <= 5'd0;
                    counting <= 1'b0;
                    done <= 1'b0;
                    count <= 4'd0;
                end

                LOAD_DELAY: begin
                    // Shift in delay bits MSB first:
                    // shift left, insert data at LSB to avoid reversal
                    delay_reg <= {delay_reg[2:0], data};
                    load_cnt <= load_cnt + 1'b1;
                    pattern_shift <= pattern_shift; // no change
                    cycle_cnt <= 10'd0;
                    blocks_remain <= 5'd0;
                    counting <= 1'b0;
                    done <= 1'b0;
                    count <= 4'd0;
                end

                COUNTING: begin
                    counting <= 1'b1;
                    done <= 1'b0;
                    pattern_shift <= pattern_shift;
                    load_cnt <= load_cnt;
                    delay_reg <= delay_reg;

                    if (cycle_cnt == 10'd999) begin
                        cycle_cnt <= 10'd0;
                        if (blocks_remain != 0)
                            blocks_remain <= blocks_remain - 1'b1;
                    end else begin
                        cycle_cnt <= cycle_cnt + 1'b1;
                    end

                    // count output shows current remaining block number (blocks_remain-1), or 0 if zero
                    if (blocks_remain == 0)
                        count <= 4'd0;
                    else
                        count <= blocks_remain - 1'b1;
                end

                DONE_WAIT: begin
                    done <= 1'b1;
                    counting <= 1'b0;
                    count <= 4'd0;
                    pattern_shift <= pattern_shift;
                    load_cnt <= load_cnt;
                    delay_reg <= delay_reg;
                    cycle_cnt <= 10'd0;
                    blocks_remain <= 5'd0;
                end
            endcase

            // Load blocks_remain at transition from LOAD_DELAY to COUNTING
            if (state == LOAD_DELAY && next_state == COUNTING) begin
                blocks_remain <= delay_reg + 1'b1;
                cycle_cnt <= 10'd0;
            end
        end
    end

    // FSM combinational next state logic
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
                // Finish counting when blocks_remain == 0 and cycle_cnt == 999
                if ((blocks_remain == 0) && (cycle_cnt == 10'd999))
                    next_state = DONE_WAIT;
            end

            DONE_WAIT: begin
                if (ack)
                    next_state = SEARCH;
            end
        endcase
    end

endmodule