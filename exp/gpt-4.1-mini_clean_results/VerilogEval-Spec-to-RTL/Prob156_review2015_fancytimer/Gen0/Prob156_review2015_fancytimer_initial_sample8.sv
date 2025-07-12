module TopModule (
    input clk,
    input reset,
    input data,
    output reg [3:0] count,
    output reg counting,
    output reg done,
    input ack
);

    // States
    typedef enum reg [1:0] {
        SEARCH     = 2'b00,
        SHIFT_DELAY= 2'b01,
        COUNTING   = 2'b10,
        DONE_STATE = 2'b11
    } state_t;
    reg [1:0] state, next_state;

    reg [3:0] shift_reg;      // To detect pattern and shift delay bits
    reg [2:0] delay_bits_in;  // Counts how many delay bits shifted in (0 to 4)
    reg [3:0] delay;          // The loaded delay value

    reg [11:0] cycle_count;   // Count clock cycles up to 1000
    reg [3:0] remaining;      // Remaining delay counter, from delay down to 0

    // Detect pattern 1101 in shift_reg
    wire pattern_detected = (shift_reg == 4'b1101);

    // FSM next state logic
    always @(*) begin
        next_state = state;
        case(state)
            SEARCH: begin
                if (pattern_detected)
                    next_state = SHIFT_DELAY;
            end
            SHIFT_DELAY: begin
                if (delay_bits_in == 4)
                    next_state = COUNTING;
            end
            COUNTING: begin
                if ((remaining == 0) && (cycle_count == 999))
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
            shift_reg <= 4'b0000;
            delay_bits_in <= 0;
            delay <= 0;
            counting <= 0;
            done <= 0;
            cycle_count <= 0;
            remaining <= 0;
            count <= 4'bxxxx; // don't care, but assign something
        end else begin
            state <= next_state;

            case(state)
                SEARCH: begin
                    done <= 0;
                    counting <= 0;
                    count <= 4'bxxxx; // Don't care when not counting
                    // shift in data for pattern detection
                    shift_reg <= {shift_reg[2:0], data};
                    delay_bits_in <= 0;
                    cycle_count <= 0;
                    remaining <= 0;
                    delay <= 0;
                end

                SHIFT_DELAY: begin
                    counting <= 0;
                    done <= 0;
                    count <= 4'bxxxx; // don't care
                    // shift in 4 delay bits MSB first
                    // shift_reg holds delay bits now
                    shift_reg <= {shift_reg[2:0], data};
                    delay_bits_in <= delay_bits_in + 1;

                    // After 4 bits shifted in delay will be in shift_reg
                    // We wait for 4 bits, so on next_state to COUNTING we load delay
                    if (delay_bits_in == 3) begin
                        // After shifting 4 bits, shift_reg[3:0] = delay bits MSB first
                        delay <= {shift_reg[2:0], data};
                        remaining <= {shift_reg[2:0], data};
                        cycle_count <= 0;
                    end
                end

                COUNTING: begin
                    done <= 0;
                    counting <= 1;
                    count <= remaining;

                    if (cycle_count == 999) begin
                        cycle_count <= 0;
                        if (remaining != 0)
                            remaining <= remaining - 1;
                    end else begin
                        cycle_count <= cycle_count + 1;
                    end
                    // ignore data input during counting and done states
                    shift_reg <= shift_reg;
                    delay_bits_in <= delay_bits_in;
                    delay <= delay;
                end

                DONE_STATE: begin
                    counting <= 0;
                    done <= 1;
                    count <= 4'bxxxx; // don't care
                    // ignore data input, wait for ack
                    shift_reg <= shift_reg;
                    delay_bits_in <= 0;
                    delay <= 0;
                    cycle_count <= 0;
                    remaining <= 0;
                end
            endcase
        end
    end

endmodule