module TopModule (
    input         clk,
    input         reset,   // synchronous active high
    input         data,
    output reg [3:0] count,
    output reg      counting,
    output reg      done,
    input         ack
);

    // State encoding
    typedef enum reg [1:0] {
        S_SEARCH     = 2'd0,
        S_LOAD_DELAY = 2'd1,
        S_COUNT      = 2'd2,
        S_DONE       = 2'd3
    } state_t;

    state_t state, next_state;

    // For pattern detection: 4-bit shift register, LSB-first shifting
    reg [3:0] pattern_shift;

    // For delay loading: 4-bit shift register, MSB-first shifting
    reg [3:0] delay_reg;
    reg [2:0] delay_bit_index;  // counts down from 3 to 0 for loading bits

    // Counting registers
    reg [19:0] total_cycle_countdown; // counts down from (delay+1)*1000 to 0
    reg [9:0]  cycle_count_in_1000;  // counts 0..999 for 1000 cycles block
    reg [3:0]  current_count;         // current count value for output (delay down to 0)

    // Pattern to detect (1101), reversed for LSB-first: 1101 = bits [3]=1, [2]=1, [1]=0, [0]=1
    // pattern_shift receives bits LSB first, so pattern to detect is 1011 (binary 'b1011)
    localparam [3:0] PATTERN = 4'b1011;

    // Sequential logic: state and registers
    always @(posedge clk) begin
        if (reset) begin
            state <= S_SEARCH;
            pattern_shift <= 4'b0000;
            delay_reg <= 4'b0000;
            delay_bit_index <= 3'd3;
            total_cycle_countdown <= 20'd0;
            cycle_count_in_1000 <= 10'd0;
            current_count <= 4'd0;
            count <= 4'd0;
            counting <= 1'b0;
            done <= 1'b0;
        end else begin
            state <= next_state;

            case (state)
                S_SEARCH: begin
                    // Shift in new bit LSB first: shift right, new bit enters MSB
                    // But problem says serial data is available at data input pin, input pattern is 1101 MSB first.
                    // We choose to shift LSB first for pattern detection:
                    // Shift left by 1, insert data at LSB:
                    pattern_shift <= {data, pattern_shift[3:1]};
                    // Reset others
                    delay_reg <= 4'b0000;
                    delay_bit_index <= 3'd3;
                    total_cycle_countdown <= 20'd0;
                    cycle_count_in_1000 <= 10'd0;
                    current_count <= 4'd0;
                    count <= 4'd0;
                    counting <= 1'b0;
                    done <= 1'b0;
                end

                S_LOAD_DELAY: begin
                    // Load delay bits MSB first: shift left, insert new bit at LSB
                    delay_reg <= {delay_reg[2:0], data};

                    if (delay_bit_index != 3'd0) begin
                        delay_bit_index <= delay_bit_index - 1'b1;
                    end

                    // Keep outputs stable
                    pattern_shift <= pattern_shift;
                    cycle_count_in_1000 <= 10'd0;
                    counting <= 1'b0;
                    done <= 1'b0;
                    current_count <= current_count;
                    count <= 4'd0;
                    total_cycle_countdown <= 20'd0;
                end

                S_COUNT: begin
                    // Counting state
                    pattern_shift <= pattern_shift;
                    delay_reg <= delay_reg;
                    delay_bit_index <= delay_bit_index;

                    counting <= 1'b1;
                    done <= 1'b0;

                    if (total_cycle_countdown != 0) begin
                        total_cycle_countdown <= total_cycle_countdown - 1'b1;

                        if (cycle_count_in_1000 == 10'd999) begin
                            cycle_count_in_1000 <= 10'd0;
                            // Update current_count when 1000 cycles passed
                            if (current_count != 0)
                                current_count <= current_count - 1'b1;
                            else
                                current_count <= 4'd0;
                        end else begin
                            cycle_count_in_1000 <= cycle_count_in_1000 + 1'b1;
                        end

                        count <= current_count;
                    end else begin
                        // Counting finished
                        cycle_count_in_1000 <= 10'd0;
                        current_count <= 4'd0;
                        count <= 4'd0;
                    end
                end

                S_DONE: begin
                    // Assert done until ack
                    pattern_shift <= pattern_shift;
                    delay_reg <= delay_reg;
                    delay_bit_index <= delay_bit_index;

                    counting <= 1'b0;
                    done <= 1'b1;
                    count <= 4'd0;
                    total_cycle_countdown <= 20'd0;
                    cycle_count_in_1000 <= 10'd0;
                    current_count <= 4'd0;
                end

                default: begin
                    state <= S_SEARCH;
                    pattern_shift <= 4'b0000;
                    delay_reg <= 4'b0000;
                    delay_bit_index <= 3'd3;
                    total_cycle_countdown <= 20'd0;
                    cycle_count_in_1000 <= 10'd0;
                    current_count <= 4'd0;
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

        case (state)
            S_SEARCH: begin
                // Detect pattern 1101 (reversed 1011 in LSB first)
                if (pattern_shift == PATTERN) begin
                    next_state = S_LOAD_DELAY;
                end
            end

            S_LOAD_DELAY: begin
                // Wait until all 4 bits loaded (delay_bit_index == 0 after decrement)
                if (delay_bit_index == 0) begin
                    next_state = S_COUNT;
                end
            end

            S_COUNT: begin
                // Finish counting when total_cycle_countdown == 0
                if (total_cycle_countdown == 0) begin
                    next_state = S_DONE;
                end
            end

            S_DONE: begin
                if (ack)
                    next_state = S_SEARCH;
            end

            default: next_state = S_SEARCH;
        endcase
    end

    // Start counting initialization: compute total_cycle_countdown and current_count when entering COUNT state
    reg state_was_count;
    always @(posedge clk) begin
        if (reset) begin
            state_was_count <= 1'b0;
        end else begin
            state_was_count <= (state == S_COUNT);
        end
    end

    always @(posedge clk) begin
        if (!state_was_count && (next_state == S_COUNT)) begin
            // Compute total cycles = (delay_reg + 1)*1000
            // delay_reg contains delay bits MSB first already

            total_cycle_countdown <= ( ( {16'd0, delay_reg} + 1 ) * 20'd1000 );

            current_count <= delay_reg;  // Output count starts from delay_reg down to 0
            cycle_count_in_1000 <= 10'd0;
        end
    end

endmodule