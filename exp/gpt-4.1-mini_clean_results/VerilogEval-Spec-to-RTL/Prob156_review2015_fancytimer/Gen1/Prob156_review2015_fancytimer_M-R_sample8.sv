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
        SEARCH = 2'd0,
        SHIFT_DELAY = 2'd1,
        COUNTING = 2'd2,
        DONE_WAIT_ACK = 2'd3
    } state_t;

    reg [1:0] state, next_state;

    // Shift register for pattern detection
    reg [3:0] pattern_shift;

    // Delay register (shift in 4 bits MSB first)
    reg [3:0] delay;

    // Count how many bits shifted in delay stage (0 to 4)
    reg [2:0] delay_bits_shifted;

    // Count clock cycles within a 1000-cycle block (0 to 999)
    reg [9:0] cycle_counter;

    // Count number of 1000-cycle blocks left to count
    // Initialized to delay+1
    reg [4:0] delay_counter;

    localparam [3:0] PATTERN = 4'b1101;

    // Sequential logic: state and counters
    always @(posedge clk) begin
        if (reset) begin
            state <= SEARCH;
            pattern_shift <= 4'b0;
            delay <= 4'b0;
            delay_bits_shifted <= 3'd0;
            cycle_counter <= 10'd0;
            delay_counter <= 5'd0;
            count <= 4'b0;
            counting <= 1'b0;
            done <= 1'b0;
        end else begin
            state <= next_state;

            case (state)
                SEARCH: begin
                    // Shift in data to detect pattern
                    pattern_shift <= {pattern_shift[2:0], data};
                    // Reset outputs and counters
                    counting <= 1'b0;
                    done <= 1'b0;
                    count <= 4'b0;
                    delay_bits_shifted <= 3'd0;
                    cycle_counter <= 10'd0;
                    delay_counter <= 5'd0;
                    delay <= 4'b0;
                end

                SHIFT_DELAY: begin
                    // Shift in delay bits MSB first on each clock
                    delay <= {delay[2:0], data};
                    delay_bits_shifted <= delay_bits_shifted + 1'b1;
                    counting <= 1'b0;
                    done <= 1'b0;
                    count <= 4'b0;
                    cycle_counter <= 10'd0;
                    delay_counter <= 5'd0;
                end

                COUNTING: begin
                    counting <= 1'b1;
                    done <= 1'b0;

                    // Increment cycle counter each clock
                    if (cycle_counter == 10'd999) begin
                        cycle_counter <= 10'd0;
                        if (delay_counter != 0)
                            delay_counter <= delay_counter - 1'b1;
                        // else remain 0
                    end else begin
                        cycle_counter <= cycle_counter + 1'b1;
                    end

                    // count output is current remaining time segment (delay_counter - 1)
                    // delay_counter counts total blocks left including current one, so subtract 1
                    if (delay_counter != 0)
                        count <= delay_counter - 1'b1;
                    else
                        count <= 4'd0; // should not happen mid-count, but safe default
                end

                DONE_WAIT_ACK: begin
                    counting <= 1'b0;
                    done <= 1'b1;
                    count <= 4'b0;
                    // Hold all counters, wait for ack
                end

                default: begin
                    // Should never happen, safe defaults
                    state <= SEARCH;
                    pattern_shift <= 4'b0;
                    delay <= 4'b0;
                    delay_bits_shifted <= 3'd0;
                    cycle_counter <= 10'd0;
                    delay_counter <= 5'd0;
                    count <= 4'b0;
                    counting <= 1'b0;
                    done <= 1'b0;
                end
            endcase
        end
    end

    // Next state combinational logic
    always @(*) begin
        next_state = state;
        case(state)
            SEARCH: begin
                if (pattern_shift == PATTERN)
                    next_state = SHIFT_DELAY;
            end

            SHIFT_DELAY: begin
                // After shifting 4 delay bits, go to COUNTING
                if (delay_bits_shifted == 3'd4)
                    next_state = COUNTING;
            end

            COUNTING: begin
                // When delay_counter and cycle_counter finished counting all blocks
                if (delay_counter == 0 && cycle_counter == 10'd999)
                    next_state = DONE_WAIT_ACK;
            end

            DONE_WAIT_ACK: begin
                if (ack)
                    next_state = SEARCH;
            end

            default: next_state = SEARCH;
        endcase
    end

    // Initialize delay_counter when entering COUNTING
    // Using a flag to detect state transitions
    reg prev_counting;

    always @(posedge clk) begin
        if (reset) begin
            prev_counting <= 1'b0;
        end else begin
            prev_counting <= (state == COUNTING);
        end
    end

    always @(posedge clk) begin
        if (!prev_counting && (state == COUNTING)) begin
            // On entering COUNTING state, initialize delay_counter to delay+1
            delay_counter <= {1'b0, delay} + 1'b1; // 5 bits to avoid overflow
            cycle_counter <= 10'd0;
        end
    end

endmodule