module TopModule (
    input        clk,
    input        reset,  // synchronous active-high reset
    input        data,
    output reg [3:0] count,
    output reg       counting,
    output reg       done,
    input        ack
);

    // One-hot state encoding
    localparam SEARCH     = 4'b0001;
    localparam LOAD_DELAY = 4'b0010;
    localparam COUNTING   = 4'b0100;
    localparam DONE       = 4'b1000;

    reg [3:0] state, next_state;

    // Pattern detection shift register (4 bits)
    reg [3:0] pattern_shift;

    // Delay register and bit counter for loading delay (4 bits delay)
    reg [3:0] delay_reg;
    reg [2:0] delay_bit_count;

    // Counters for timing
    reg [9:0] cycle_counter; // counts 0..999 cycles per tick
    reg [3:0] tick_counter;  // counts remaining ticks

    wire pattern_match = (pattern_shift == 4'b1101);

    // Next state logic combinational
    always @(*) begin
        case (state)
            SEARCH:     next_state = pattern_match ? LOAD_DELAY : SEARCH;
            LOAD_DELAY: next_state = (delay_bit_count == 4) ? COUNTING : LOAD_DELAY;
            COUNTING:   next_state = (tick_counter == 0 && cycle_counter == 10'd999) ? DONE : COUNTING;
            DONE:       next_state = ack ? SEARCH : DONE;
            default:    next_state = SEARCH;
        endcase
    end

    // Sequential logic: state update and outputs
    always @(posedge clk) begin
        if (reset) begin
            state <= SEARCH;
            pattern_shift <= 4'b0;
            delay_reg <= 4'b0;
            delay_bit_count <= 3'd0;
            cycle_counter <= 10'd0;
            tick_counter <= 4'd0;
            count <= 4'd0;
            counting <= 1'b0;
            done <= 1'b0;
        end else begin
            state <= next_state;

            case(state)
                SEARCH: begin
                    // Shift pattern register left and input data bit at LSB (serial MSB first not needed here)
                    pattern_shift <= {pattern_shift[2:0], data};

                    // Clear delay registers and counters for next use
                    delay_reg <= 4'b0;
                    delay_bit_count <= 3'd0;
                    cycle_counter <= 10'd0;
                    tick_counter <= 4'd0;

                    // Outputs
                    counting <= 1'b0;
                    done <= 1'b0;
                    count <= 4'd0;
                end

                LOAD_DELAY: begin
                    // Shift delay_reg left by 1, insert incoming bit at LSB (MSB first load)
                    delay_reg <= {delay_reg[2:0], data};
                    delay_bit_count <= delay_bit_count + 1'b1;

                    // Hold pattern_shift steady (no update)
                    pattern_shift <= pattern_shift;

                    // Outputs disabled during delay load
                    counting <= 1'b0;
                    done <= 1'b0;
                    count <= 4'd0;

                    // Counters not counting yet
                    cycle_counter <= 10'd0;
                    tick_counter <= 4'd0;
                end

                COUNTING: begin
                    // Hold pattern_shift (no update during counting)
                    pattern_shift <= pattern_shift;

                    counting <= 1'b1;
                    done <= 1'b0;
                    count <= tick_counter;

                    if (cycle_counter == 10'd999) begin
                        cycle_counter <= 10'd0;
                        if (tick_counter != 0) begin
                            tick_counter <= tick_counter - 1'b1;
                        end
                        // else tick_counter == 0 means counting done next cycle
                    end else begin
                        cycle_counter <= cycle_counter + 1'b1;
                    end
                end

                DONE: begin
                    // Hold pattern_shift
                    pattern_shift <= pattern_shift;

                    counting <= 1'b0;
                    done <= 1'b1;
                    count <= 4'd0;

                    // Hold delay_reg and counters until ack
                    delay_reg <= delay_reg;
                    delay_bit_count <= 3'd0;
                    cycle_counter <= 10'd0;
                    tick_counter <= 4'd0;
                end

                default: begin
                    state <= SEARCH;
                    pattern_shift <= 4'b0;
                    delay_reg <= 4'b0;
                    delay_bit_count <= 3'd0;
                    cycle_counter <= 10'd0;
                    tick_counter <= 4'd0;
                    count <= 4'd0;
                    counting <= 1'b0;
                    done <= 1'b0;
                end
            endcase

            // On transition from LOAD_DELAY to COUNTING, initialize tick_counter with delay_reg and reset cycle_counter
            if (state == LOAD_DELAY && next_state == COUNTING) begin
                tick_counter <= delay_reg;
                cycle_counter <= 10'd0;
            end
        end
    end

endmodule