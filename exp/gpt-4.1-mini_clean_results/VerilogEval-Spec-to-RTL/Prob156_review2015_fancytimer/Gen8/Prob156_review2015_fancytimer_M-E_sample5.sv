module TopModule(
    input        clk,
    input        reset,  // synchronous active high
    input        data,
    output reg [3:0] count,
    output reg   counting,
    output reg   done,
    input        ack
);

    // FSM states
    localparam IDLE      = 2'd0;
    localparam LOAD_DELAY= 2'd1;
    localparam COUNTING  = 2'd2;
    localparam DONE      = 2'd3;

    reg [1:0] state, next_state;

    // Shift register to detect pattern 1101 in IDLE
    reg [3:0] pattern_shift;

    // Delay shift register and bit counter during LOAD_DELAY
    reg [3:0] delay_reg;
    reg [2:0] delay_bits_loaded;  // 0 to 4 bits loaded

    // Counting registers
    reg [9:0] cycle_count;        // counts 0 to 999 for 1000 cycles
    reg [4:0] blocks_remaining;   // counts (delay+1) blocks (max 17)
                                 // 5 bits to hold max (15+1)
    reg [3:0] count_reg;          // current count output during COUNTING

    // FSM sequential
    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            pattern_shift <= 4'd0;
            delay_reg <= 4'd0;
            delay_bits_loaded <= 3'd0;
            cycle_count <= 10'd0;
            blocks_remaining <= 5'd0;
            count_reg <= 4'd0;
            counting <= 1'b0;
            done <= 1'b0;
            count <= 4'bx; // don't care at reset
        end else begin
            state <= next_state;

            case(state)
                IDLE: begin
                    done <= 1'b0;
                    counting <= 1'b0;
                    // Shift in pattern bits MSB first: shift left, append data LSB
                    // After many cycles, pattern_shift holds last 4 bits shifted in MSB first
                    pattern_shift <= {pattern_shift[2:0], data};

                    // Clear delay load info
                    delay_bits_loaded <= 3'd0;
                    delay_reg <= 4'd0;

                    // Clear counters
                    cycle_count <= 10'd0;
                    blocks_remaining <= 5'd0;
                    count_reg <= 4'd0;

                    count <= 4'bx; // don't care when idle
                end

                LOAD_DELAY: begin
                    done <= 1'b0;
                    counting <= 1'b0;

                    // Shift delay bits in MSB first:
                    // Shift delay_reg left, insert data at LSB
                    delay_reg <= {delay_reg[2:0], data};
                    delay_bits_loaded <= delay_bits_loaded + 1'b1;

                    // Keep pattern_shift stable (not used here)
                    pattern_shift <= pattern_shift;

                    // Counters remain zero
                    cycle_count <= 10'd0;
                    blocks_remaining <= 5'd0;
                    count_reg <= 4'd0;

                    count <= 4'bx; // don't care loading delay
                end

                COUNTING: begin
                    done <= 1'b0;
                    counting <= 1'b1;

                    pattern_shift <= pattern_shift;
                    delay_reg <= delay_reg;
                    delay_bits_loaded <= delay_bits_loaded;

                    // Cycle counter counts 0..999 for 1000 cycles
                    if (cycle_count == 10'd999) begin
                        cycle_count <= 10'd0;

                        // Decrement blocks_remaining if >0
                        if (blocks_remaining > 0)
                            blocks_remaining <= blocks_remaining - 1'b1;

                        // Update count output (remaining blocks -1)
                        if (blocks_remaining > 1)
                            count_reg <= blocks_remaining - 1'b1;
                        else
                            count_reg <= 4'd0;

                    end else begin
                        cycle_count <= cycle_count + 1'b1;
                    end

                    count <= count_reg;
                end

                DONE: begin
                    done <= 1'b1;
                    counting <= 1'b0;

                    pattern_shift <= pattern_shift;
                    delay_reg <= delay_reg;
                    delay_bits_loaded <= delay_bits_loaded;

                    cycle_count <= 10'd0;
                    blocks_remaining <= 5'd0;
                    count_reg <= 4'd0;

                    count <= 4'bx; // don't care when done
                end

                default: begin
                    // Default safe reset
                    state <= IDLE;
                    pattern_shift <= 4'd0;
                    delay_reg <= 4'd0;
                    delay_bits_loaded <= 3'd0;
                    cycle_count <= 10'd0;
                    blocks_remaining <= 5'd0;
                    count_reg <= 4'd0;
                    counting <= 1'b0;
                    done <= 1'b0;
                    count <= 4'bx;
                end
            endcase
        end
    end

    // FSM combinational next state logic
    always @(*) begin
        next_state = state;

        case(state)
            IDLE: begin
                // Wait for pattern 1101
                if (pattern_shift == 4'b1101)
                    next_state = LOAD_DELAY;
            end

            LOAD_DELAY: begin
                // After 4 delay bits loaded, go to COUNTING
                if (delay_bits_loaded == 3'd4)
                    next_state = COUNTING;
            end

            COUNTING: begin
                // When blocks_remaining reaches 0 and cycle_count completes 1000 cycles, go to DONE
                // However, blocks_remaining is decremented only at cycle_count=999.
                // So when blocks_remaining==0 and cycle_count==999 (end of last block), we go DONE
                if ((blocks_remaining == 0) && (cycle_count == 10'd999))
                    next_state = DONE;
            end

            DONE: begin
                // Wait for ack to return to IDLE
                if (ack)
                    next_state = IDLE;
            end

            default: next_state = IDLE;
        endcase
    end

    // On transition to COUNTING state, initialize blocks_remaining and counters
    reg state_dly;  // delayed state for edge detect on LOAD_DELAY->COUNTING
    always @(posedge clk) begin
        if (reset) begin
            state_dly <= 1'b0;
        end else begin
            state_dly <= (state == LOAD_DELAY);
        end
    end

    wire load_to_count = (state_dly && (next_state == COUNTING));
    always @(posedge clk) begin
        if (!reset && load_to_count) begin
            // blocks_remaining = delay_reg + 1
            blocks_remaining <= delay_reg + 1'b1;
            // Initialize count output to delay_reg value
            count_reg <= delay_reg;
            // Reset cycle counter
            cycle_count <= 10'd0;
        end
    end

endmodule