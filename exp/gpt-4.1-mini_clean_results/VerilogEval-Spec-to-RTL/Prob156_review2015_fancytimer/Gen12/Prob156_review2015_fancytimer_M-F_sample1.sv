module TopModule (
    input  wire       clk,
    input  wire       reset,   // synchronous active-high reset
    input  wire       data,
    output reg [3:0]  count,
    output reg        counting,
    output reg        done,
    input  wire       ack
);

    // State encoding
    typedef enum logic [2:0] {
        SEARCH     = 3'd0,
        LOAD       = 3'd1,
        INIT_COUNT = 3'd2,
        COUNT      = 3'd3,
        WAIT_ACK   = 3'd4
    } state_t;

    state_t state, next_state;

    // Pattern detection shift register (4 bits)
    reg [3:0] pattern_shift;

    // Delay register and bit count
    reg [3:0] delay_reg;
    reg [2:0] delay_bits_received; // counts 0..4

    // Counting registers
    reg [9:0] cycle_counter;  // counts 0..999 (1000 cycles)
    reg [3:0] tick_counter;   // counts intervals remaining

    // Detect pattern 1101
    wire pattern_matched = (pattern_shift == 4'b1101);

    // FSM next state logic
    always @(*) begin
        case (state)
            SEARCH:
                if (pattern_matched)
                    next_state = LOAD;
                else
                    next_state = SEARCH;

            LOAD:
                if (delay_bits_received == 4)
                    next_state = INIT_COUNT;
                else
                    next_state = LOAD;

            INIT_COUNT:
                next_state = COUNT;

            COUNT:
                // End counting after completing all intervals and cycle_counter reaches 999
                if ((tick_counter == 0) && (cycle_counter == 10'd999))
                    next_state = WAIT_ACK;
                else
                    next_state = COUNT;

            WAIT_ACK:
                if (ack)
                    next_state = SEARCH;
                else
                    next_state = WAIT_ACK;

            default:
                next_state = SEARCH;
        endcase
    end

    // Sequential logic and outputs
    always @(posedge clk) begin
        if (reset) begin
            // Synchronous reset all regs and outputs
            state <= SEARCH;
            pattern_shift <= 4'b0000;
            delay_reg <= 4'b0000;
            delay_bits_received <= 3'd0;
            cycle_counter <= 10'd0;
            tick_counter <= 4'd0;
            count <= 4'd0;
            counting <= 1'b0;
            done <= 1'b0;
        end else begin
            state <= next_state;

            case (state)

                SEARCH: begin
                    // Shift in data bit for pattern detection
                    pattern_shift <= {pattern_shift[2:0], data};
                    delay_bits_received <= 3'd0;
                    delay_reg <= 4'b0000;
                    cycle_counter <= 10'd0;
                    tick_counter <= 4'd0;
                    count <= 4'd0;      // don't-care replaced with zero for synthesis friendliness
                    counting <= 1'b0;
                    done <= 1'b0;
                end

                LOAD: begin
                    // Shift in delay bits MSB first
                    delay_reg <= {delay_reg[2:0], data};
                    delay_bits_received <= delay_bits_received + 1'b1;
                    // Freeze unrelated regs
                    pattern_shift <= pattern_shift;
                    cycle_counter <= 10'd0;
                    tick_counter <= 4'd0;
                    count <= 4'd0;
                    counting <= 1'b0;
                    done <= 1'b0;
                end

                INIT_COUNT: begin
                    // Initialize counters for counting phase
                    cycle_counter <= 10'd0;
                    tick_counter <= delay_reg + 1'b1; // total intervals to count
                    count <= delay_reg;                // initial remaining intervals (delay)
                    counting <= 1'b1;
                    done <= 1'b0;
                    pattern_shift <= pattern_shift;
                    delay_reg <= delay_reg;
                    delay_bits_received <= delay_bits_received;
                end

                COUNT: begin
                    counting <= 1'b1;
                    done <= 1'b0;

                    pattern_shift <= pattern_shift;
                    delay_reg <= delay_reg;
                    delay_bits_received <= delay_bits_received;

                    if (cycle_counter == 10'd999) begin
                        cycle_counter <= 10'd0;
                        if (tick_counter > 0) begin
                            tick_counter <= tick_counter - 1'b1;
                        end
                        // Update count output after decrementing tick_counter
                        // count holds intervals remaining minus one, or 0 if none remain
                        if (tick_counter > 1)
                            count <= tick_counter - 2; // because tick_counter just decremented
                        else
                            count <= 4'd0;
                    end else begin
                        cycle_counter <= cycle_counter + 1'b1;
                        // Keep count stable during this 1000-cycle segment
                    end
                end

                WAIT_ACK: begin
                    counting <= 1'b0;
                    done <= 1'b1;
                    count <= 4'd0; // don't-care replaced by zero
                    // Clear registers for next SEARCH cycle
                    pattern_shift <= 4'b0000;
                    delay_reg <= 4'b0000;
                    delay_bits_received <= 3'd0;
                    cycle_counter <= 10'd0;
                    tick_counter <= 4'd0;
                end

                default: begin
                    // Safe default state
                    state <= SEARCH;
                    pattern_shift <= 4'b0000;
                    delay_reg <= 4'b0000;
                    delay_bits_received <= 3'd0;
                    cycle_counter <= 10'd0;
                    tick_counter <= 4'd0;
                    count <= 4'd0;
                    counting <= 1'b0;
                    done <= 1'b0;
                end
            endcase
        end
    end

endmodule