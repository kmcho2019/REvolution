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
    typedef enum reg [2:0] {
        SEARCH = 3'd0,
        SHIFT_DELAY = 3'd1,
        COUNTING = 3'd2,
        DONE_WAIT_ACK = 3'd3
    } state_t;

    reg [2:0] state, next_state;

    // Shift register for pattern detection (4 bits)
    reg [3:0] pattern_shift;

    // Shift register for delay bits
    reg [3:0] delay;

    // Counter for clock cycles in the counting phase
    reg [9:0] cycle_counter; // counts 0 to 999 (1000 cycles)

    // Delay counter for counting down remaining delay values
    reg [3:0] delay_counter;

    // Pattern to detect: 1101 (binary)
    localparam [3:0] PATTERN = 4'b1101;

    // Sequential logic: state machine and registers
    always @(posedge clk) begin
        if (reset) begin
            state <= SEARCH;
            pattern_shift <= 4'b0000;
            delay <= 4'b0000;
            delay_counter <= 4'b0000;
            cycle_counter <= 10'd0;
            count <= 4'b0000;
            counting <= 1'b0;
            done <= 1'b0;
        end else begin
            state <= next_state;

            case (state)
                SEARCH: begin
                    // Shift in new data bit into pattern_shift
                    pattern_shift <= {pattern_shift[2:0], data};
                    // clear outputs
                    counting <= 1'b0;
                    done <= 1'b0;
                    count <= 4'b0000; // don't care when not counting

                    // No other register updates needed here
                end

                SHIFT_DELAY: begin
                    // shift in delay bits MSB first on each clock
                    // We'll shift left and put new data in LSB:
                    delay <= {delay[2:0], data};
                    // keep outputs off
                    counting <= 1'b0;
                    done <= 1'b0;
                    count <= 4'b0000; // don't care

                    // cycle_counter and delay_counter not touched here
                end

                COUNTING: begin
                    counting <= 1'b1;
                    done <= 1'b0;

                    if (cycle_counter == 10'd999) begin
                        cycle_counter <= 10'd0;
                        if (delay_counter != 0) begin
                            delay_counter <= delay_counter - 1'b1;
                        end
                    end else begin
                        cycle_counter <= cycle_counter + 1'b1;
                    end
                    count <= delay_counter;
                end

                DONE_WAIT_ACK: begin
                    counting <= 1'b0;
                    done <= 1'b1;
                    count <= 4'b0000; // don't care
                end

                default: begin
                    // default to SEARCH on any invalid state
                    state <= SEARCH;
                    counting <= 1'b0;
                    done <= 1'b0;
                    count <= 4'b0000;
                    pattern_shift <= 4'b0000;
                    delay <= 4'b0000;
                    delay_counter <= 4'b0000;
                    cycle_counter <= 10'd0;
                end
            endcase
        end
    end

    // Next state logic
    always @(*) begin
        next_state = state;
        case (state)
            SEARCH: begin
                // Check for pattern detection
                if (pattern_shift == PATTERN) begin
                    next_state = SHIFT_DELAY;
                end
            end

            SHIFT_DELAY: begin
                // After shifting in 4 delay bits, move to counting
                // We count bits shifted in with a 2-bit counter (not explicitly stored, so count delay bits shifted in)
                // We'll track this by counting the state cycles - but because we shift in 4 bits in 4 clocks, 
                // after 4 clocks in SHIFT_DELAY state we go to COUNTING.

                // To implement this cleanly, keep a shift count
                // But since only 4 bits shifted, better to keep a counter for bits shifted in.

                // We'll implement a 2-bit counter for shift count.

                // To keep combinational logic clean, move this counting to an internal register updated with state.

                // To solve this, add a bits_shifted reg for SHIFT_DELAY.

                // For now, let's fix this by adding a 3-bit shift counter.

                // We'll add a bits_shifted register below.

                // Can't do in combinational always block, so assign here after.

                // For now, if bits_shifted == 4 move to COUNTING

            end

            COUNTING: begin
                // When delay_counter == 0 and cycle_counter == 999, counting done
                if ((delay_counter == 0) && (cycle_counter == 10'd999)) begin
                    next_state = DONE_WAIT_ACK;
                end
            end

            DONE_WAIT_ACK: begin
                // Wait for ack == 1 to go back to SEARCH
                if (ack) begin
                    next_state = SEARCH;
                end
            end
        endcase
    end

    // Implement bits_shifted counter for SHIFT_DELAY state
    reg [2:0] bits_shifted;

    always @(posedge clk) begin
        if (reset) begin
            bits_shifted <= 3'd0;
        end else begin
            if (state == SHIFT_DELAY) begin
                bits_shifted <= bits_shifted + 1'b1;
            end else begin
                bits_shifted <= 3'd0;
            end
        end
    end

    // Adjust next_state logic for SHIFT_DELAY using bits_shifted
    always @(*) begin
        if (state == SHIFT_DELAY && bits_shifted == 3'd4) begin
            next_state = COUNTING;
        end
    end

    // Initialize delay_counter and cycle_counter when entering COUNTING
    always @(posedge clk) begin
        if (reset) begin
            delay_counter <= 4'b0000;
            cycle_counter <= 10'd0;
        end else begin
            // When we transition from SHIFT_DELAY to COUNTING, initialize counters
            if (state == SHIFT_DELAY && bits_shifted == 3'd4 && next_state == COUNTING) begin
                delay_counter <= delay;
                cycle_counter <= 10'd0;
            end
        end
    end

endmodule