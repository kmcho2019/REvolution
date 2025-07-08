module TopModule (
    input clk,
    input reset,
    input data,
    output reg [3:0] count,
    output reg counting,
    output reg done,
    input ack
);

    // FSM states
    typedef enum logic [1:0] {
        SEARCH = 2'b00,
        SHIFT_DELAY = 2'b01,
        COUNT = 2'b10,
        DONE_STATE = 2'b11
    } state_t;

    state_t state, next_state;

    // Shift register for pattern detection
    reg [3:0] pattern_shift;

    // Shift register for delay bits
    reg [3:0] delay;

    // Bit count for shifting delay bits
    reg [2:0] delay_bits_shifted;

    // 10-bit counter for 1000 clock cycles
    reg [9:0] cycle_count;

    // Remaining delay counts (counts down from delay to 0)
    reg [3:0] remaining_delay;

    // Next state logic combinational
    always @(*) begin
        next_state = state;
        case(state)
            SEARCH: begin
                // When pattern detected, move to SHIFT_DELAY
                if (pattern_shift == 4'b1101)
                    next_state = SHIFT_DELAY;
            end
            SHIFT_DELAY: begin
                if (delay_bits_shifted == 4)
                    next_state = COUNT;
            end
            COUNT: begin
                if ((remaining_delay == 0) && (cycle_count == 0))
                    next_state = DONE_STATE;
            end
            DONE_STATE: begin
                if (ack)
                    next_state = SEARCH;
            end
        endcase
    end

    // Sequential logic
    always @(posedge clk) begin
        if (reset) begin
            state <= SEARCH;
            pattern_shift <= 4'b0000;
            delay <= 4'b0000;
            delay_bits_shifted <= 0;
            cycle_count <= 0;
            remaining_delay <= 0;
            counting <= 1'b0;
            done <= 1'b0;
            count <= 4'bxxxx; // don't care
        end else begin
            state <= next_state;
            case(state)
                SEARCH: begin
                    counting <= 1'b0;
                    done <= 1'b0;
                    count <= 4'bxxxx; // don't care in SEARCH
                    // Shift in data for pattern detection
                    pattern_shift <= {pattern_shift[2:0], data};
                    delay_bits_shifted <= 0;
                    delay <= 4'b0000;
                    cycle_count <= 0;
                    remaining_delay <= 0;
                end
                SHIFT_DELAY: begin
                    done <= 1'b0;
                    counting <= 1'b0;
                    // Shift in next delay bit MSB first:
                    // We shift in one bit per clock, so shift left and OR data at LSB
                    delay <= {delay[2:0], data};
                    delay_bits_shifted <= delay_bits_shifted + 1'b1;
                    count <= 4'bxxxx; // don't care until counting
                end
                COUNT: begin
                    done <= 1'b0;
                    counting <= 1'b1;

                    // On cycle_count == 0, load 999 (1000 cycles counting 0..999)
                    // Otherwise count down cycle_count
                    if (cycle_count == 0) begin
                        cycle_count <= 10'd999;
                        if (remaining_delay == 4'bxxxx || remaining_delay == 0) begin
                            // When entering counting state, load remaining_delay from delay
                            if (remaining_delay == 0 && count != 4'bxxxx) begin
                                // no action: end counting handled in next_state
                            end else begin
                                remaining_delay <= delay;
                            end
                        end else begin
                            // Decrement remaining_delay by 1 each 1000 cycles
                            remaining_delay <= remaining_delay - 1'b1;
                        end
                    end else begin
                        cycle_count <= cycle_count - 1'b1;
                    end

                    // Output count is current remaining_delay
                    // For the first 1000 cycles, count shows delay,
                    // then delay-1, ..., 0 for last 1000 cycles
                    count <= remaining_delay;
                end
                DONE_STATE: begin
                    done <= 1'b1;
                    counting <= 1'b0;
                    count <= 4'bxxxx; // don't care while done
                    // Wait for ack, then reset FSM to SEARCH
                    // No other actions here, next_state handles FSM transition
                end
            endcase
        end
    end

endmodule