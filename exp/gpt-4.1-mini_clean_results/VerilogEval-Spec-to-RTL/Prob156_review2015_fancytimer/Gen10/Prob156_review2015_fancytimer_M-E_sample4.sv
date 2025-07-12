module TopModule(
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
        SEARCH = 2'd0,
        LOAD   = 2'd1,
        COUNT  = 2'd2,
        DONE   = 2'd3
    } state_t;

    state_t state, next_state;

    // Shift register for pattern detection (4 bits)
    reg [3:0] pattern_shift;

    // Shift register for delay loading (4 bits)
    reg [3:0] delay_shift;
    reg [2:0] delay_bits_loaded; // 0..4

    // Counting total cycles left: max (16 * 1000 = 16000 < 2^14 = 16384)
    reg [13:0] cycle_counter; // counts down from (delay+1)*1000 to zero

    // To produce count output: remaining blocks = ceil(cycle_counter/1000)-1 = blocks left - 1
    // We can track remaining blocks as cycle_counter / 1000 (integer division)
    // Since each block is 1000 cycles, use dividers with counters:
    // Instead of division, maintain a separate block counter.

    // We track blocks_left separately, initialized to (delay + 1)
    reg [4:0] blocks_left; // 0..17 enough to cover max 16+1 blocks

    // Cycle count within current block 0..999
    reg [9:0] block_cycle_count;

    // Synchronous sequential block
    always @(posedge clk) begin
        if (reset) begin
            state <= SEARCH;
            pattern_shift <= 4'd0;
            delay_shift <= 4'd0;
            delay_bits_loaded <= 3'd0;
            cycle_counter <= 14'd0;
            blocks_left <= 5'd0;
            block_cycle_count <= 10'd0;
            count <= 4'd0;
            counting <= 1'b0;
            done <= 1'b0;
        end else begin
            state <= next_state;

            case(state)
                SEARCH: begin
                    // Shift pattern register left, insert new bit at LSB
                    pattern_shift <= {pattern_shift[2:0], data};

                    // Clear delay loading registers and counters
                    delay_shift <= 4'd0;
                    delay_bits_loaded <= 3'd0;

                    // Clear counting registers
                    cycle_counter <= 14'd0;
                    blocks_left <= 5'd0;
                    block_cycle_count <= 10'd0;

                    // Outputs in SEARCH state
                    counting <= 1'b0;
                    done <= 1'b0;
                    count <= 4'd0;
                end

                LOAD: begin
                    // Shift delay bits left, insert new bit at LSB
                    delay_shift <= {delay_shift[2:0], data};
                    delay_bits_loaded <= delay_bits_loaded + 1'b1;

                    // Hold pattern_shift stable (no update needed here)
                    pattern_shift <= pattern_shift;

                    // Clear counting outputs until counting starts
                    counting <= 1'b0;
                    done <= 1'b0;
                    count <= 4'd0;

                    // Clear counting registers (will init at COUNT start)
                    cycle_counter <= 14'd0;
                    blocks_left <= 5'd0;
                    block_cycle_count <= 10'd0;
                end

                COUNT: begin
                    // No pattern or delay loading in COUNT
                    pattern_shift <= pattern_shift;
                    delay_shift <= delay_shift;
                    delay_bits_loaded <= delay_bits_loaded;

                    // Counting operation
                    if (cycle_counter > 0) begin
                        cycle_counter <= cycle_counter - 1'b1;
                    end else begin
                        cycle_counter <= 14'd0;
                    end

                    // Block cycle counter counts 0..999 per block
                    if (block_cycle_count == 10'd999) begin
                        block_cycle_count <= 10'd0;
                        if (blocks_left > 0) begin
                            blocks_left <= blocks_left - 1'b1;
                        end
                    end else begin
                        block_cycle_count <= block_cycle_count + 1'b1;
                    end

                    counting <= 1'b1;
                    done <= 1'b0;

                    // count output = blocks_left - 1 if blocks_left > 0 else 0
                    // blocks_left counts how many 1000-cycle blocks remain
                    // For correct behavior, blocks_left should never be zero while counting,
                    // because after last block it goes to DONE. But safe to clamp output.
                    count <= (blocks_left > 0) ? (blocks_left - 1'b1) : 4'd0;
                end

                DONE: begin
                    // Hold registers stable
                    pattern_shift <= pattern_shift;
                    delay_shift <= delay_shift;
                    delay_bits_loaded <= delay_bits_loaded;
                    cycle_counter <= 14'd0;
                    blocks_left <= 5'd0;
                    block_cycle_count <= 10'd0;

                    counting <= 1'b0;
                    done <= 1'b1;
                    count <= 4'd0;
                end

                default: begin
                    // Should never happen, reset FSM and outputs
                    state <= SEARCH;
                    pattern_shift <= 4'd0;
                    delay_shift <= 4'd0;
                    delay_bits_loaded <= 3'd0;
                    cycle_counter <= 14'd0;
                    blocks_left <= 5'd0;
                    block_cycle_count <= 10'd0;
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
            SEARCH: begin
                if (pattern_shift == 4'b1101) begin
                    next_state = LOAD;
                end else begin
                    next_state = SEARCH;
                end
            end

            LOAD: begin
                if (delay_bits_loaded == 3'd4) begin
                    next_state = COUNT;
                end else begin
                    next_state = LOAD;
                end
            end

            COUNT: begin
                // When all cycles counted down (cycle_counter == 0 and block_cycle_count == 999, meaning last cycle of last block)
                // move to DONE state
                // cycle_counter is already counting total cycles left
                if ((cycle_counter == 14'd0) && (block_cycle_count == 10'd999)) begin
                    next_state = DONE;
                end else begin
                    next_state = COUNT;
                end
            end

            DONE: begin
                // Wait for ack to restart searching
                if (ack) begin
                    next_state = SEARCH;
                end else begin
                    next_state = DONE;
                end
            end

            default: next_state = SEARCH;
        endcase
    end

    // Initialize counters at LOAD->COUNT transition
    reg prev_load;
    always @(posedge clk) begin
        if (reset) begin
            prev_load <= 1'b0;
        end else begin
            prev_load <= (state == LOAD);
        end
    end

    wire load_to_count = (prev_load && (state == COUNT));

    always @(posedge clk) begin
        if (reset) begin
            cycle_counter <= 14'd0;
            blocks_left <= 5'd0;
            block_cycle_count <= 10'd0;
            count <= 4'd0;
        end else if (load_to_count) begin
            // Initialize total cycles and blocks_left at start of COUNT
            cycle_counter <= (delay_shift + 1) * 14'd1000;
            blocks_left <= delay_shift + 1;
            block_cycle_count <= 10'd0;
            count <= delay_shift;
        end
    end

endmodule