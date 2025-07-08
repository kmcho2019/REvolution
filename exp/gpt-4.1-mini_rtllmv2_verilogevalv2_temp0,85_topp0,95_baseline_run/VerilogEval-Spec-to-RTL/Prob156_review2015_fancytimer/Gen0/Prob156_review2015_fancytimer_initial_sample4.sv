module TopModule(
    input clk,
    input reset,
    input data,
    output reg [3:0] count,
    output reg counting,
    output reg done,
    input ack
);

    // States
    localparam SEARCH       = 2'd0;
    localparam SHIFT_DELAY  = 2'd1;
    localparam COUNTING     = 2'd2;
    localparam DONE_STATE   = 2'd3;

    reg [1:0] state, next_state;

    // Shift register to detect pattern 1101
    reg [3:0] pattern_shift;

    // Delay register (loaded after pattern detected)
    reg [3:0] delay;

    // Counter to count the total cycles (max 16 * 1000 = 16000 cycles fits in 15 bits)
    reg [13:0] cycle_counter; // 14 bits enough for max 16000

    // Count how many bits of delay have been shifted in (0 to 4)
    reg [2:0] delay_bits_shifted;

    // For counting the current 1000-cycle block inside counting state
    reg [9:0] cycle_1000_counter; // counts 0..999

    // Internal: current remaining delay count (count output)
    reg [3:0] remaining_delay;

    // Pattern detection and FSM state update
    always @(posedge clk) begin
        if (reset) begin
            state <= SEARCH;
            pattern_shift <= 4'b0000;
            delay <= 4'd0;
            delay_bits_shifted <= 3'd0;
            cycle_counter <= 14'd0;
            cycle_1000_counter <= 10'd0;
            remaining_delay <= 4'd0;
            count <= 4'bxxxx;  // don't care
            counting <= 1'b0;
            done <= 1'b0;
        end else begin
            state <= next_state;

            case(state)
                SEARCH: begin
                    done <= 1'b0;
                    counting <= 1'b0;
                    count <= 4'bxxxx; // don't care
                    // shift pattern_shift in new data bit
                    pattern_shift <= {pattern_shift[2:0], data};
                    delay_bits_shifted <= 3'd0;
                end

                SHIFT_DELAY: begin
                    // shift delay bits MSB first into delay register
                    // we shift 4 bits, starting from delay_bits_shifted=0 to 3
                    // delay[3] is MSB, delay[0] is LSB
                    // shift in data bit by bit on each clk
                    delay <= {delay[2:0], data};
                    delay_bits_shifted <= delay_bits_shifted + 1'b1;
                end

                COUNTING: begin
                    done <= 1'b0;
                    counting <= 1'b1;

                    if (cycle_1000_counter == 10'd999) begin
                        cycle_1000_counter <= 10'd0;
                        if (remaining_delay != 4'd0)
                            remaining_delay <= remaining_delay - 1'b1;
                    end else begin
                        cycle_1000_counter <= cycle_1000_counter + 1'b1;
                    end

                    cycle_counter <= cycle_counter + 1'b1;
                    count <= remaining_delay;
                end

                DONE_STATE: begin
                    done <= 1'b1;
                    counting <= 1'b0;
                    count <= 4'bxxxx; // don't care
                end

                default: begin
                    // default safe values
                    done <= 1'b0;
                    counting <= 1'b0;
                    count <= 4'bxxxx;
                end
            endcase
        end
    end

    // FSM next state logic
    always @(*) begin
        next_state = state;
        case(state)
            SEARCH: begin
                // detect pattern 1101 in pattern_shift (pattern_shift holds last 4 bits)
                // pattern is 4'b1101 = 4'b1101 = 4'b13 in decimal
                if (pattern_shift == 4'b1101)
                    next_state = SHIFT_DELAY;
                else
                    next_state = SEARCH;
            end

            SHIFT_DELAY: begin
                // after shifting in 4 bits delay, move to counting
                if (delay_bits_shifted == 3'd4)
                    next_state = COUNTING;
                else
                    next_state = SHIFT_DELAY;
            end

            COUNTING: begin
                // count total cycles = (delay+1)*1000 cycles
                // cycle_counter counts from 0 upwards
                if (cycle_counter == ((delay + 1) * 1000) - 1)
                    next_state = DONE_STATE;
                else
                    next_state = COUNTING;
            end

            DONE_STATE: begin
                // wait for ack=1 before returning to SEARCH
                if (ack)
                    next_state = SEARCH;
                else
                    next_state = DONE_STATE;
            end

            default: next_state = SEARCH;
        endcase
    end

    // Additional logic for initializing counters at state transitions
    always @(posedge clk) begin
        if (reset) begin
            // already reset above
        end else begin
            // On state transitions perform initialization where needed
            if (state != next_state) begin
                case (next_state)
                    SHIFT_DELAY: begin
                        delay <= 4'd0;
                        delay_bits_shifted <= 3'd0;
                    end
                    COUNTING: begin
                        // Initialize counters for counting
                        cycle_counter <= 14'd0;
                        cycle_1000_counter <= 10'd0;
                        remaining_delay <= delay;
                        count <= delay;
                    end
                    DONE_STATE: begin
                        // No counters needed
                        cycle_counter <= 14'd0;
                        cycle_1000_counter <= 10'd0;
                    end
                    SEARCH: begin
                        pattern_shift <= 4'b0000;
                        delay <= 4'd0;
                        delay_bits_shifted <= 3'd0;
                        cycle_counter <= 14'd0;
                        cycle_1000_counter <= 10'd0;
                        remaining_delay <= 4'd0;
                        count <= 4'bxxxx;
                    end
                endcase
            end
        end
    end

endmodule