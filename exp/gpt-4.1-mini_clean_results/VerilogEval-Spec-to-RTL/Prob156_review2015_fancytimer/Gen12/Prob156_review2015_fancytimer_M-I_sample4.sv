module TopModule(
    input        clk,
    input        reset, // synchronous active high
    input        data,
    output reg [3:0] count,
    output reg   counting,
    output reg   done,
    input        ack
);

    // FSM states as parameters (standard Verilog)
    localparam SEARCH      = 2'd0;
    localparam LOAD_DELAY  = 2'd1;
    localparam COUNTING    = 2'd2;
    localparam DONE_WAIT   = 2'd3;

    reg [1:0] state, next_state;

    reg [3:0] pattern_shift;
    reg [2:0] load_cnt;
    reg [3:0] delay_reg;

    reg [9:0] cycle_cnt;      // counts 0..999 cycles
    reg [4:0] blocks_remain;  // delay+1 blocks remaining

    // Synchronous reset and state transitions
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
                    // Shift pattern window left, input LSB
                    pattern_shift <= {pattern_shift[2:0], data};
                    load_cnt <= 3'd0;
                    delay_reg <= 4'd0;
                    cycle_cnt <= 10'd0;
                    blocks_remain <= 5'd0;
                    count <= 4'd0;
                    counting <= 1'b0;
                    done <= 1'b0;
                end

                LOAD_DELAY: begin
                    // Shift in delay bits MSB first:
                    // Insert data at MSB, shift right one
                    delay_reg <= {data, delay_reg[3:1]};
                    load_cnt <= load_cnt + 1'b1;
                    // keep pattern_shift unchanged
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

                    // count output shows current remaining block value (countdown)
                    // blocks_remain counts down from delay+1 to 0,
                    // the displayed count is blocks_remain - 1
                    if (blocks_remain == 0) begin
                        count <= 4'd0;
                    end else begin
                        count <= (blocks_remain - 1'b1)[3:0];
                    end
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

            // On transition from LOAD_DELAY to COUNTING, load blocks_remain
            if (state == LOAD_DELAY && next_state == COUNTING) begin
                blocks_remain <= delay_reg + 1'b1;
                cycle_cnt <= 10'd0;
            end
        end
    end

    // Next state logic
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
                // finished counting when blocks_remain==0 and last cycle completed
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