module TopModule(
    input         clk,
    input         reset,   // synchronous active high
    input         data,
    output reg [3:0] count,
    output reg    counting,
    output reg    done,
    input         ack
);

    // State encoding
    localparam SEARCH     = 2'd0;
    localparam LOAD_DELAY = 2'd1;
    localparam COUNTING   = 2'd2;
    localparam DONE       = 2'd3;

    reg [1:0] state, next_state;

    // Pattern detection shift register (for SEARCH)
    reg [3:0] pattern_shift;

    // Delay bits loading
    reg [3:0] delay;
    reg [2:0] delay_bits_loaded; // counts 0..3 for 4 bits

    // Counters for counting delay cycles
    reg [9:0] cycle_counter; // counts down 0..999 (1000 cycles)
    reg [4:0] block_counter; // delay+1 max 5 bits to avoid overflow

    // Sequential logic
    always @(posedge clk) begin
        if (reset) begin
            state <= SEARCH;
            pattern_shift <= 4'b0;
            delay <= 4'b0;
            delay_bits_loaded <= 3'b0;
            cycle_counter <= 10'b0;
            block_counter <= 5'b0;
            counting <= 1'b0;
            done <= 1'b0;
            count <= 4'b0;
        end else begin
            state <= next_state;

            case(state)
                SEARCH: begin
                    // Shift pattern register with incoming data bit
                    pattern_shift <= {pattern_shift[2:0], data};
                    delay_bits_loaded <= 3'b0;
                    // Outputs
                    counting <= 1'b0;
                    done <= 1'b0;
                    count <= 4'b0;
                    cycle_counter <= 10'b0;
                    block_counter <= 5'b0;
                    delay <= delay; // hold delay stable
                end

                LOAD_DELAY: begin
                    // Shift delay bits MSB first: shift left + insert data at LSB
                    // So first bit shifted in goes to delay[3], last to delay[0]
                    delay <= {delay[2:0], data};
                    delay_bits_loaded <= delay_bits_loaded + 1'b1;

                    // Outputs inactive during load delay
                    counting <= 1'b0;
                    done <= 1'b0;
                    count <= 4'b0;
                    cycle_counter <= 10'b0;
                    block_counter <= 5'b0;
                    pattern_shift <= pattern_shift; // hold pattern
                end

                COUNTING: begin
                    counting <= 1'b1;
                    done <= 1'b0;

                    // Decrement cycle counter
                    if (cycle_counter == 0) begin
                        if (block_counter > 1) begin
                            // Reload cycle counter for next 1000 cycles
                            cycle_counter <= 10'd999;
                            block_counter <= block_counter - 1'b1;
                        end else begin
                            // Last block counted, stay at zero
                            cycle_counter <= 10'd0;
                            block_counter <= 5'd0;
                        end
                    end else begin
                        cycle_counter <= cycle_counter - 1'b1;
                        block_counter <= block_counter; // hold stable
                    end

                    // Output count = block_counter - 1 when block_counter>0, else 0
                    if (block_counter > 0)
                        count <= block_counter[3:0] - 1'b1;
                    else
                        count <= 4'b0;

                    // pattern_shift and delay hold stable
                    pattern_shift <= pattern_shift;
                    delay <= delay;
                    delay_bits_loaded <= delay_bits_loaded;
                end

                DONE: begin
                    counting <= 1'b0;
                    done <= 1'b1;
                    count <= 4'b0;

                    // Hold registers stable
                    pattern_shift <= pattern_shift;
                    delay <= delay;
                    delay_bits_loaded <= 3'b0;
                    cycle_counter <= 10'b0;
                    block_counter <= 5'b0;
                end

                default: begin
                    // Defensive reset to SEARCH
                    state <= SEARCH;
                    pattern_shift <= 4'b0;
                    delay <= 4'b0;
                    delay_bits_loaded <= 3'b0;
                    cycle_counter <= 10'b0;
                    block_counter <= 5'b0;
                    counting <= 1'b0;
                    done <= 1'b0;
                    count <= 4'b0;
                end
            endcase

            // Initialize counters at transition from LOAD_DELAY when 4 bits loaded
            // This avoids multiple always blocks conflicting
            if (state == LOAD_DELAY && delay_bits_loaded == 3'd4) begin
                block_counter <= delay + 1'b1;      // delay+1 blocks of 1000 cycles
                cycle_counter <= 10'd999;            // start counting first 1000 cycles
            end
        end
    end

    // Next state combinational logic
    always @(*) begin
        next_state = state;

        case(state)
            SEARCH: begin
                // Detect pattern 1101
                if (pattern_shift == 4'b1101) begin
                    next_state = LOAD_DELAY;
                end
            end

            LOAD_DELAY: begin
                // Wait until 4 delay bits loaded
                if (delay_bits_loaded == 3'd4) begin
                    next_state = COUNTING;
                end
            end

            COUNTING: begin
                // When counting finished (both counters zero)
                if (block_counter == 0 && cycle_counter == 0) begin
                    next_state = DONE;
                end
            end

            DONE: begin
                // Wait for ack to return to SEARCH state
                if (ack) begin
                    next_state = SEARCH;
                end
            end

            default: next_state = SEARCH;
        endcase
    end

endmodule