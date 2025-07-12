module TopModule (
    input         clk,
    input         reset,   // synchronous active high
    input         data,
    output reg [3:0] count,
    output reg    counting,
    output reg    done,
    input         ack
);

    // FSM States
    typedef enum logic [1:0] {
        SEARCH     = 2'b00,
        DELAY_LOAD = 2'b01,
        COUNT      = 2'b10,
        WAIT_ACK   = 2'b11
    } state_t;

    state_t state, next_state;

    // Shift registers for pattern detection and delay load
    reg [3:0] pattern_shift;
    reg [3:0] delay_reg;
    reg [2:0] delay_bits_loaded; // 0..4

    // Counters for timing
    reg [9:0] cycle_counter;  // counts 0..999 (1000 cycles)
    reg [4:0] tick_counter;   // counts remaining ticks = delay+1 max 17

    // Synchronous process: state and registers update
    always @(posedge clk) begin
        if (reset) begin
            state <= SEARCH;
            pattern_shift <= 4'b0;
            delay_reg <= 4'b0;
            delay_bits_loaded <= 3'd0;
            cycle_counter <= 10'd0;
            tick_counter <= 5'd0;
            counting <= 1'b0;
            done <= 1'b0;
            count <= 4'b0;
        end else begin
            state <= next_state;

            case(state)
                SEARCH: begin
                    // Shift right: insert new bit at MSB for MSB-first input
                    pattern_shift <= {data, pattern_shift[3:1]};
                    delay_bits_loaded <= 3'd0;
                    delay_reg <= delay_reg; // hold
                    cycle_counter <= 10'd0;
                    tick_counter <= 5'd0;
                    counting <= 1'b0;
                    done <= 1'b0;
                    count <= 4'b0;
                end

                DELAY_LOAD: begin
                    // Shift right: insert new bit at MSB (MSB-first)
                    delay_reg <= {data, delay_reg[3:1]};
                    delay_bits_loaded <= delay_bits_loaded + 1'b1;
                    pattern_shift <= pattern_shift; // hold
                    cycle_counter <= 10'd0;
                    tick_counter <= 5'd0;
                    counting <= 1'b0;
                    done <= 1'b0;
                    count <= 4'b0;
                end

                COUNT: begin
                    counting <= 1'b1;
                    done <= 1'b0;

                    if (cycle_counter == 10'd999) begin
                        cycle_counter <= 10'd0;

                        if (tick_counter > 0) begin
                            tick_counter <= tick_counter - 1'b1;
                            count <= tick_counter - 1'b1; // count stable during next 1000 cycles
                        end else begin
                            // Counting done: hold count at zero
                            tick_counter <= 5'd0;
                            count <= 4'd0;
                        end
                    end else begin
                        cycle_counter <= cycle_counter + 1'b1;
                        // count stable during 1000 cycles
                        count <= count;
                        tick_counter <= tick_counter;
                    end

                    // Initialize counters when entering COUNT state
                    if (state != COUNT) begin
                        cycle_counter <= 10'd0;
                        tick_counter <= delay_reg + 5'd1; // delay+1
                        count <= delay_reg;
                    end
                end

                WAIT_ACK: begin
                    // Clear all counting variables
                    pattern_shift <= 4'b0;
                    delay_reg <= 4'b0;
                    delay_bits_loaded <= 3'd0;
                    cycle_counter <= 10'd0;
                    tick_counter <= 5'd0;
                    counting <= 1'b0;
                    done <= 1'b1;
                    count <= 4'b0;
                end

                default: begin
                    // Defensive reset to SEARCH state
                    state <= SEARCH;
                    pattern_shift <= 4'b0;
                    delay_reg <= 4'b0;
                    delay_bits_loaded <= 3'd0;
                    cycle_counter <= 10'd0;
                    tick_counter <= 5'd0;
                    counting <= 1'b0;
                    done <= 1'b0;
                    count <= 4'b0;
                end
            endcase
        end
    end

    // Combinational process: next state logic
    always @(*) begin
        next_state = state;

        case(state)
            SEARCH: begin
                // Detect pattern 1101 (MSB-first)
                if (pattern_shift == 4'b1101)
                    next_state = DELAY_LOAD;
                else
                    next_state = SEARCH;
            end

            DELAY_LOAD: begin
                if (delay_bits_loaded == 3'd4)
                    next_state = COUNT;
                else
                    next_state = DELAY_LOAD;
            end

            COUNT: begin
                // Move to WAIT_ACK after counting all ticks and cycles
                if ((tick_counter == 0) && (cycle_counter == 10'd999))
                    next_state = WAIT_ACK;
                else
                    next_state = COUNT;
            end

            WAIT_ACK: begin
                if (ack)
                    next_state = SEARCH;
                else
                    next_state = WAIT_ACK;
            end

            default: next_state = SEARCH;
        endcase
    end

endmodule