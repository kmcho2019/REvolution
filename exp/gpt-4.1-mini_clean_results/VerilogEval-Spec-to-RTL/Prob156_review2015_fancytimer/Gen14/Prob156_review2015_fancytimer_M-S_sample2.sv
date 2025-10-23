module TopModule(
    input        clk,
    input        reset,    // synchronous active high
    input        data,
    output reg [3:0] count,
    output reg   counting,
    output reg   done,
    input        ack
);

    // State encoding
    localparam SEARCH     = 2'd0;
    localparam LOAD_DELAY = 2'd1;
    localparam COUNTING   = 2'd2;
    localparam DONE       = 2'd3;

    reg [1:0] state, next_state;

    // Shift register for pattern detection and delay loading
    reg [3:0] shift_reg;

    // For LOAD_DELAY: count bits loaded (0 to 3)
    reg [2:0] load_bit_cnt;

    // Delay value loaded after pattern detected
    reg [3:0] delay;

    // Counting logic:
    reg [9:0] cycle_cnt;   // counts down from 999 to 0 (for 1000 cycles)
    reg [4:0] block_cnt;   // counts down blocks (delay+1 max 16)

    // Sequential state and registers update
    always @(posedge clk) begin
        if (reset) begin
            state <= SEARCH;
            shift_reg <= 4'd0;
            load_bit_cnt <= 3'd0;
            delay <= 4'd0;
            cycle_cnt <= 10'd0;
            block_cnt <= 5'd0;
            count <= 4'd0;
            counting <= 1'b0;
            done <= 1'b0;
        end else begin
            state <= next_state;

            case(state)
                SEARCH: begin
                    counting <= 1'b0;
                    done <= 1'b0;
                    count <= 4'd0;
                    load_bit_cnt <= 3'd0;

                    // Shift pattern register
                    shift_reg <= {shift_reg[2:0], data};
                end

                LOAD_DELAY: begin
                    counting <= 1'b0;
                    done <= 1'b0;
                    count <= 4'd0;

                    // Shift in delay bits MSB first
                    shift_reg <= {shift_reg[2:0], data};
                    load_bit_cnt <= load_bit_cnt + 1'b1;

                    // Delay loaded after 4 bits shifted, latch delay
                    if (load_bit_cnt == 3'd3) begin
                        delay <= {shift_reg[2:0], data}; // last loaded 4 bits
                    end
                end

                COUNTING: begin
                    counting <= 1'b1;
                    done <= 1'b0;

                    // Decrement cycle counter
                    if (cycle_cnt == 10'd0) begin
                        cycle_cnt <= 10'd999;

                        // Decrement block counter when cycle_cnt reaches zero
                        if (block_cnt != 0)
                            block_cnt <= block_cnt - 1'b1;

                        // Update count to current remaining blocks - 1 or 0
                        if (block_cnt > 1)
                            count <= block_cnt - 2; // block_cnt-1 minus 1 for zero-based count
                        else
                            count <= 4'd0;
                    end else begin
                        cycle_cnt <= cycle_cnt - 1'b1;
                        // Count remains stable within the 1000-cycle block
                    end
                end

                DONE: begin
                    counting <= 1'b0;
                    done <= 1'b1;
                    count <= 4'd0;
                    // Hold registers steady until ack
                end

                default: begin
                    state <= SEARCH;
                    shift_reg <= 4'd0;
                    load_bit_cnt <= 3'd0;
                    delay <= 4'd0;
                    cycle_cnt <= 10'd0;
                    block_cnt <= 5'd0;
                    count <= 4'd0;
                    counting <= 1'b0;
                    done <= 1'b0;
                end
            endcase
        end
    end

    // Next state logic
    always @(*) begin
        next_state = state;
        case(state)
            SEARCH: begin
                if (shift_reg == 4'b1101)
                    next_state = LOAD_DELAY;
            end

            LOAD_DELAY: begin
                if (load_bit_cnt == 3'd4)
                    next_state = COUNTING;
            end

            COUNTING: begin
                // Done when all blocks and cycles counted down
                if ((block_cnt == 0) && (cycle_cnt == 0))
                    next_state = DONE;
            end

            DONE: begin
                if (ack)
                    next_state = SEARCH;
            end

            default: next_state = SEARCH;
        endcase
    end

    // Initialize counters when entering COUNTING state
    always @(posedge clk) begin
        if (reset) begin
            cycle_cnt <= 10'd0;
            block_cnt <= 5'd0;
        end else if ((state == LOAD_DELAY) && (load_bit_cnt == 3'd4)) begin
            cycle_cnt <= 10'd999; // start at 999 for 1000 cycle count
            block_cnt <= delay + 1'b1; // total blocks = delay+1
        end
    end

endmodule