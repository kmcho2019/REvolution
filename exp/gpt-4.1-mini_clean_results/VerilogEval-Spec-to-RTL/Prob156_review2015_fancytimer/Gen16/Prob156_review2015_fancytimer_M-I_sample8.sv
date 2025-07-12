module TopModule (
    input        clk,
    input        reset,    // synchronous active high
    input        data,
    output reg [3:0] count,
    output reg   counting,
    output reg   done,
    input        ack
);

    // FSM states
    localparam PATTERN_DETECT = 2'd0;
    localparam LOAD_DELAY     = 2'd1;
    localparam COUNTING       = 2'd2;
    localparam DONE_STATE     = 2'd3;

    reg [1:0] state, next_state;

    // Pattern detector shift register (4 bits)
    reg [3:0] pattern_shift;

    wire pattern_match = (pattern_shift == 4'b1101);

    // Delay load registers
    reg [3:0] delay_shift;
    reg [2:0] delay_bit_cnt; // count bits shifted in 0..3
    reg [3:0] delay_value;

    // Counting variables
    localparam integer CYCLES_PER_BLOCK = 1000;

    reg [3:0] block_count;      // counts from delay_value+1 down to 0
    reg [9:0] subcycle_count;   // counts 999 down to 0

    // Sequential logic
    always @(posedge clk) begin
        if (reset) begin
            state <= PATTERN_DETECT;
            pattern_shift <= 4'b0000;
            delay_shift <= 4'd0;
            delay_bit_cnt <= 3'd0;
            delay_value <= 4'd0;
            block_count <= 4'd0;
            subcycle_count <= 10'd0;
            count <= 4'd0;
            counting <= 1'b0;
            done <= 1'b0;
        end else begin
            state <= next_state;

            case (state)
                PATTERN_DETECT: begin
                    counting <= 1'b0;
                    done <= 1'b0;
                    count <= 4'd0; // stable 0

                    // Shift pattern register to detect start pattern
                    pattern_shift <= {pattern_shift[2:0], data};

                    // Clear delay load registers
                    delay_shift <= 4'd0;
                    delay_bit_cnt <= 3'd0;
                    delay_value <= 4'd0;
                    block_count <= 4'd0;
                    subcycle_count <= 10'd0;
                end

                LOAD_DELAY: begin
                    counting <= 1'b0;
                    done <= 1'b0;
                    count <= 4'd0; // stable 0

                    // Shift in delay bits MSB first
                    delay_shift <= {delay_shift[2:0], data};
                    delay_bit_cnt <= delay_bit_cnt + 1'b1;

                    // After last bit shifted in (bit 3), latch delay_value
                    if (delay_bit_cnt == 3'd3) begin
                        delay_value <= {delay_shift[2:0], data};
                    end

                    // Keep pattern_shift stable (do not shift pattern anymore)
                    // No pattern detection in load delay
                end

                COUNTING: begin
                    counting <= 1'b1;
                    done <= 1'b0;
                    // output current remaining block_count - 1, since block_count counts down including block 0
                    // but per spec count output = remaining blocks delay down to 0 stable for 1000 cycles each
                    count <= block_count - 1;

                    // Counting logic
                    if (subcycle_count == 0) begin
                        // End of a 1000-cycle block
                        if (block_count != 0) begin
                            block_count <= block_count - 1'b1;
                            subcycle_count <= CYCLES_PER_BLOCK - 1;
                        end else begin
                            // block_count == 0 and subcycle_count == 0 means counting done
                            // hold counters stable here; FSM will move to DONE_STATE
                            subcycle_count <= 0;
                            block_count <= 0;
                        end
                    end else begin
                        // Decrement subcycle_count within block
                        subcycle_count <= subcycle_count - 1'b1;
                    end
                end

                DONE_STATE: begin
                    counting <= 1'b0;
                    done <= 1'b1;
                    count <= 4'd0; // stable 0 during done

                    // Hold registers stable until ack
                    // No changes needed here
                end

                default: begin
                    // Defensive: reset to PATTERN_DETECT
                    state <= PATTERN_DETECT;
                    pattern_shift <= 4'b0000;
                    delay_shift <= 4'd0;
                    delay_bit_cnt <= 3'd0;
                    delay_value <= 4'd0;
                    block_count <= 4'd0;
                    subcycle_count <= 10'd0;
                    count <= 4'd0;
                    counting <= 1'b0;
                    done <= 1'b0;
                end
            endcase
        end
    end

    // Next state combinational logic
    always @(*) begin
        next_state = state;
        case (state)
            PATTERN_DETECT: begin
                if (pattern_match)
                    next_state = LOAD_DELAY;
            end

            LOAD_DELAY: begin
                // After exactly 4 bits loaded (delay_bit_cnt counts 0..3),
                // next cycle move to COUNTING
                if (delay_bit_cnt == 3'd4) // delay_bit_cnt increments up to 4
                    next_state = COUNTING;
            end

            COUNTING: begin
                // Counting ends when block_count == 0 and subcycle_count == 0
                if ((block_count == 0) && (subcycle_count == 0))
                    next_state = DONE_STATE;
            end

            DONE_STATE: begin
                // Wait for ack to restart
                if (ack)
                    next_state = PATTERN_DETECT;
            end

            default: next_state = PATTERN_DETECT;
        endcase
    end

    // Since delay_bit_cnt is 3 bits, incrementing beyond 3 wraps to 0,
    // we extend it virtually by comparing to 4 in next_state.
    // To do so, create a 3-bit counter plus a flag indicating done:

    // Implement delay_bit_cnt increment carefully with saturation:

    // Reimplement delay_bit_cnt logic so it saturates at 4 without wrap:

    reg [2:0] delay_bit_cnt_r; // register to count 0..4 (max 4 represented as 3'b100)
    wire delay_bit_cnt_max = (delay_bit_cnt_r == 3'd4);

    // We replace delay_bit_cnt by delay_bit_cnt_r in logic.

    // Redefine sequential logic block for delay_bit_cnt:

    // Extract just delay_bit_cnt update logic:
    always @(posedge clk) begin
        if (reset) begin
            delay_bit_cnt_r <= 3'd0;
        end else begin
            if (state == LOAD_DELAY) begin
                if (!delay_bit_cnt_max) begin
                    delay_bit_cnt_r <= delay_bit_cnt_r + 1'b1;
                end
                // else hold at max 4
            end else begin
                delay_bit_cnt_r <= 3'd0;
            end
        end
    end

    // Replace usage of delay_bit_cnt with delay_bit_cnt_r,
    // and also latch delay_value on delay_bit_cnt_r == 3 (last bit shifted in),
    // transition to COUNTING when delay_bit_cnt_r == 4.

    // Also, only shift delay_shift when delay_bit_cnt_r < 4 (i.e., still shifting)

    always @(posedge clk) begin
        if (reset) begin
            delay_shift <= 4'd0;
            delay_value <= 4'd0;
        end else begin
            if (state == LOAD_DELAY) begin
                if (delay_bit_cnt_r < 3'd4) begin
                    // Shift delay bits
                    delay_shift <= {delay_shift[2:0], data};
                    // Latch delay_value on last bit shifted in (delay_bit_cnt_r==3)
                    if (delay_bit_cnt_r == 3'd3) begin
                        delay_value <= {delay_shift[2:0], data};
                    end
                end
            end else begin
                delay_shift <= 4'd0;
                delay_value <= delay_value; // hold
            end
        end
    end

    // Initialize counters when entering COUNTING state:
    // Detect rising edge of transition from LOAD_DELAY to COUNTING

    reg state_dly1;

    always @(posedge clk) begin
        if (reset) begin
            state_dly1 <= PATTERN_DETECT;
        end else begin
            state_dly1 <= state;
        end
    end

    wire start_counting_pulse = (state_dly1 == LOAD_DELAY) && (state == COUNTING);

    always @(posedge clk) begin
        if (reset) begin
            block_count <= 4'd0;
            subcycle_count <= 10'd0;
        end else begin
            if (start_counting_pulse) begin
                block_count <= delay_value + 1'b1; // count (delay+1) blocks
                subcycle_count <= CYCLES_PER_BLOCK - 1; // start at 999 cycles
            end else if (state == COUNTING) begin
                // Counting logic handled in main always block (above)
                // This block just initializes counters on start_counting_pulse
            end else begin
                block_count <= block_count; // hold
                subcycle_count <= subcycle_count; // hold
            end
        end
    end

endmodule