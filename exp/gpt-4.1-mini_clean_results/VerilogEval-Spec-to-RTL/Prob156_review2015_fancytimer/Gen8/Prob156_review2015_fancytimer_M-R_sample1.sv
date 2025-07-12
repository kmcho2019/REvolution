module TopModule (
    input         clk,
    input         reset,    // synchronous active-high reset
    input         data,
    output reg [3:0] count,
    output reg      counting,
    output reg      done,
    input          ack
);

    // State encoding
    localparam IDLE       = 2'd0;
    localparam DELAY_LOAD = 2'd1;
    localparam COUNTING   = 2'd2;
    localparam DONE       = 2'd3;

    reg [1:0] state, next_state;

    // Pattern detection shift register: MSB first shifting.
    // We shift right and shift in new bit at MSB, so that MSB is oldest bit.
    reg [3:0] pattern_shift;

    // Delay register and bit count (to count 4 bits)
    reg [3:0] delay_reg;
    reg [2:0] delay_bits_loaded;

    // Counters for counting phase
    reg [9:0] cycle_counter;  // counts 0..999 cycles per block
    reg [3:0] block_counter;  // counts down from (delay+1) to 0

    // Next-state combinational and outputs combinational
    always @(*) begin
        next_state = state;
        case(state)
            IDLE: begin
                // Wait until pattern detected
                if (pattern_shift == 4'b1101)
                    next_state = DELAY_LOAD;
            end
            DELAY_LOAD: begin
                if (delay_bits_loaded == 4)
                    next_state = COUNTING;
            end
            COUNTING: begin
                // If finished last block (block_counter=0) and cycle_counter at 999 (end of last block)
                if ((block_counter == 0) && (cycle_counter == 10'd999))
                    next_state = DONE;
            end
            DONE: begin
                if (ack)
                    next_state = IDLE;
            end
            default: next_state = IDLE;
        endcase
    end

    // Sequential block: update registers and counters
    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            pattern_shift <= 4'b0000;
            delay_reg <= 4'b0000;
            delay_bits_loaded <= 3'd0;
            cycle_counter <= 10'd0;
            block_counter <= 4'd0;
            counting <= 1'b0;
            done <= 1'b0;
            count <= 4'b0000;
        end else begin
            state <= next_state;

            case(state)
                IDLE: begin
                    // Shift in data bit MSB first for pattern detection
                    pattern_shift <= {data, pattern_shift[3:1]};
                    // Reset delay loading registers
                    delay_reg <= 4'b0000;
                    delay_bits_loaded <= 3'd0;
                    // Reset counters
                    cycle_counter <= 10'd0;
                    block_counter <= 4'd0;
                    // Outputs
                    counting <= 1'b0;
                    done <= 1'b0;
                    count <= 4'b0000; // don't care, set to 0 for stability
                end

                DELAY_LOAD: begin
                    // Keep pattern_shift stable (no pattern detection)
                    pattern_shift <= pattern_shift;
                    // Shift in delay bits MSB first
                    delay_reg <= {data, delay_reg[3:1]};
                    delay_bits_loaded <= delay_bits_loaded + 1'b1;
                    // Counters zeroed
                    cycle_counter <= 10'd0;
                    block_counter <= 4'd0;
                    // Outputs
                    counting <= 1'b0;
                    done <= 1'b0;
                    count <= 4'b0000; // don't care during delay load
                end

                COUNTING: begin
                    // Freeze pattern and delay registers
                    pattern_shift <= pattern_shift;
                    delay_reg <= delay_reg;
                    delay_bits_loaded <= delay_bits_loaded;

                    // Counting logic
                    if (cycle_counter == 10'd999) begin
                        cycle_counter <= 10'd0;
                        // Decrement block_counter if non-zero
                        if (block_counter != 0)
                            block_counter <= block_counter - 1'b1;
                    end else begin
                        cycle_counter <= cycle_counter + 1'b1;
                        block_counter <= block_counter;
                    end

                    // Outputs
                    counting <= 1'b1;
                    done <= 1'b0;
                    // count shows remaining blocks - 1 during counting
                    if (block_counter == 0)
                        count <= 4'd0;
                    else
                        count <= block_counter - 1;
                end

                DONE: begin
                    // Freeze pattern and delay registers
                    pattern_shift <= pattern_shift;
                    delay_reg <= delay_reg;
                    delay_bits_loaded <= 3'd0;
                    // Counters zeroed
                    cycle_counter <= 10'd0;
                    block_counter <= 4'd0;
                    // Outputs
                    counting <= 1'b0;
                    done <= 1'b1;
                    count <= 4'b0000; // don't care in done
                end

                default: begin
                    state <= IDLE;
                    pattern_shift <= 4'b0000;
                    delay_reg <= 4'b0000;
                    delay_bits_loaded <= 3'd0;
                    cycle_counter <= 10'd0;
                    block_counter <= 4'd0;
                    counting <= 1'b0;
                    done <= 1'b0;
                    count <= 4'b0000;
                end
            endcase

            // Load block_counter when entering COUNTING state from DELAY_LOAD
            if ((state == DELAY_LOAD) && (next_state == COUNTING)) begin
                block_counter <= delay_reg + 4'd1;
            end
        end
    end

endmodule