module TopModule(
    input clk,
    input reset,
    input data,
    output reg [3:0] count,
    output reg counting,
    output reg done,
    input ack
);

    // FSM states
    typedef enum reg [1:0] {
        SEARCH      = 2'b00,
        READ_DELAY  = 2'b01,
        COUNT       = 2'b10,
        DONE_STATE  = 2'b11
    } state_t;

    reg [1:0] state, next_state;

    // Shift register for detecting pattern 1101 (4 bits)
    reg [3:0] pattern_shift;

    // Delay register (4 bits) for timer duration
    reg [3:0] delay_reg;

    // Count of bits read for delay in READ_DELAY state (0 to 3)
    reg [2:0] delay_bits_read;

    // Counter for counting 1000 cycles per delay step
    reg [9:0] cycle_count; // 0 to 999

    // Remaining delay count during counting (counts down from delay_reg to 0)
    reg [3:0] delay_count;

    // Sequential logic: FSM, registers and outputs
    always @(posedge clk) begin
        if (reset) begin
            state <= SEARCH;
            pattern_shift <= 4'b0000;
            delay_reg <= 4'b0000;
            delay_bits_read <= 3'd0;
            cycle_count <= 10'd0;
            delay_count <= 4'd0;
            counting <= 1'b0;
            done <= 1'b0;
            count <= 4'b0000;
        end else begin
            state <= next_state;

            case(state)
                SEARCH: begin
                    // Shift in data to pattern_shift register to detect pattern 1101
                    pattern_shift <= {pattern_shift[2:0], data};

                    // outputs while searching
                    counting <= 1'b0;
                    done <= 1'b0;
                    count <= 4'b0000; // don't care value, set to zero for stability

                    // reset delay reading and counters
                    delay_bits_read <= 3'd0;
                    delay_reg <= delay_reg; // retain delay_reg
                    cycle_count <= 10'd0;
                    delay_count <= 4'd0;
                end

                READ_DELAY: begin
                    // Shift in data bit MSB first into delay_reg
                    delay_reg <= {delay_reg[2:0], data};
                    delay_bits_read <= delay_bits_read + 1'b1;

                    counting <= 1'b0;
                    done <= 1'b0;
                    count <= 4'b0000; // don't care during delay read
                    cycle_count <= 10'd0;
                    delay_count <= delay_count;
                    pattern_shift <= pattern_shift; // no update here (freeze)
                end

                COUNT: begin
                    // Freeze pattern_shift during counting (ignore data input)
                    pattern_shift <= pattern_shift;

                    counting <= 1'b1;
                    done <= 1'b0;
                    count <= delay_count;

                    // counting logic: count cycles up to 999, then decrement delay_count
                    if (cycle_count == 10'd999) begin
                        cycle_count <= 10'd0;
                        // decrement delay_count if > 0
                        if (delay_count != 4'd0)
                            delay_count <= delay_count - 1'b1;
                    end else begin
                        cycle_count <= cycle_count + 1'b1;
                        delay_count <= delay_count; // hold value until cycle_count completes
                    end
                end

                DONE_STATE: begin
                    // Freeze pattern_shift during done (ignore data input)
                    pattern_shift <= pattern_shift;

                    counting <= 1'b0;
                    done <= 1'b1;
                    count <= 4'b0000; // don't care during done

                    cycle_count <= 10'd0;
                    delay_bits_read <= 3'd0;
                    delay_reg <= delay_reg;
                    delay_count <= 4'd0;
                end

                default: begin
                    // Safety defaults
                    pattern_shift <= 4'b0000;
                    counting <= 1'b0;
                    done <= 1'b0;
                    count <= 4'b0000;
                    delay_bits_read <= 3'd0;
                    delay_reg <= 4'b0000;
                    cycle_count <= 10'd0;
                    delay_count <= 4'd0;
                end
            endcase
        end
    end

    // Next state combinational logic
    always @(*) begin
        next_state = state;
        case(state)
            SEARCH: begin
                // Detect pattern 1101 on pattern_shift after shifting in data this cycle
                // pattern_shift holds last 4 bits, pattern is 1101
                if (pattern_shift == 4'b1101) begin
                    next_state = READ_DELAY;
                end
            end

            READ_DELAY: begin
                // When 4 bits have been read into delay_reg, go to COUNT
                if (delay_bits_read == 3'd4) begin
                    next_state = COUNT;
                end
            end

            COUNT: begin
                // When delay_count = 0 and cycle_count at end (999), go to DONE
                if ((delay_count == 4'd0) && (cycle_count == 10'd999)) begin
                    next_state = DONE_STATE;
                end
            end

            DONE_STATE: begin
                // Wait for ack to restart searching
                if (ack == 1'b1) begin
                    next_state = SEARCH;
                end
            end

            default: next_state = SEARCH;
        endcase
    end

    // Initialization of delay_count at start of COUNT state
    // Use a synchronous update to load delay_count with delay_reg at state transition
    reg state_counted_last_clk; // to detect state change
    always @(posedge clk) begin
        if (reset) begin
            state_counted_last_clk <= 1'b0;
        end else begin
            // Detect if we just entered COUNT state
            if (state != COUNT && next_state == COUNT) begin
                delay_count <= delay_reg;
                cycle_count <= 10'd0;
            end
            state_counted_last_clk <= (state == COUNT);
        end
    end

endmodule