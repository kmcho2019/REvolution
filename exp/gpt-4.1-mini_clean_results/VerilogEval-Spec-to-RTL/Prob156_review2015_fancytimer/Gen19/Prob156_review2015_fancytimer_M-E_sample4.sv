module TopModule (
    input        clk,
    input        reset,   // synchronous active high
    input        data,
    output reg [3:0] count,
    output reg   counting,
    output reg   done,
    input        ack
);

    // State encoding (one-hot or binary, binary here)
    localparam SEARCH      = 3'd0;
    localparam DELAY_LOAD  = 3'd1;
    localparam COUNT_INIT  = 3'd2;
    localparam COUNT       = 3'd3;
    localparam DONE        = 3'd4;

    reg [2:0] state, next_state;

    // Shift register for pattern detection (4 bits)
    // Updated only in SEARCH state, shift left inserting data in LSB to keep MSB-first order.
    reg [3:0] pattern_shift;

    // Delay register (4 bits) loading MSB first in DELAY_LOAD
    reg [3:0] delay_reg;
    reg [2:0] delay_bits_count; // counts 0 to 4 bits loaded

    // Counters for counting timing
    reg [9:0] cycle_counter;    // counts 0..999 cycles per tick
    reg [3:0] tick_counter;     // counts down from delay+1 to 0

    // Constant start pattern
    localparam [3:0] START_PATTERN = 4'b1101;

    // Sequential logic: state and registers
    always @(posedge clk) begin
        if (reset) begin
            state <= SEARCH;
            pattern_shift <= 4'd0;
            delay_reg <= 4'd0;
            delay_bits_count <= 3'd0;
            cycle_counter <= 10'd0;
            tick_counter <= 4'd0;
            count <= 4'd0;
            counting <= 1'b0;
            done <= 1'b0;
        end else begin
            state <= next_state;

            case (state)
                SEARCH: begin
                    // Shift in data bit into pattern_shift MSB first: shift left, new bit at LSB
                    pattern_shift <= {pattern_shift[2:0], data};
                    delay_bits_count <= 3'd0;
                    delay_reg <= delay_reg; // hold
                    cycle_counter <= 10'd0;
                    tick_counter <= 4'd0;
                    counting <= 1'b0;
                    done <= 1'b0;
                    count <= 4'd0;
                end

                DELAY_LOAD: begin
                    // Shift in delay bits MSB first: shift left and insert data at LSB
                    delay_reg <= {delay_reg[2:0], data};
                    delay_bits_count <= delay_bits_count + 1'b1;
                    pattern_shift <= pattern_shift; // hold
                    cycle_counter <= 10'd0;
                    tick_counter <= 4'd0;
                    counting <= 1'b0;
                    done <= 1'b0;
                    count <= 4'd0;
                end

                COUNT_INIT: begin
                    // Initialize counters for counting
                    tick_counter <= delay_reg + 1'b1; // number of ticks
                    cycle_counter <= 10'd0;
                    counting <= 1'b1;
                    done <= 1'b0;
                    // Outputs
                    count <= delay_reg; // Initially count = delay (one less than tick_counter)
                    // Hold registers
                    pattern_shift <= pattern_shift;
                    delay_reg <= delay_reg;
                    delay_bits_count <= delay_bits_count;
                end

                COUNT: begin
                    counting <= 1'b1;
                    done <= 1'b0;
                    pattern_shift <= pattern_shift;
                    delay_reg <= delay_reg;
                    delay_bits_count <= delay_bits_count;

                    if (cycle_counter == 10'd999) begin
                        cycle_counter <= 10'd0;

                        if (tick_counter != 0) begin
                            tick_counter <= tick_counter - 1'b1;
                        end else begin
                            // tick_counter is zero, hold
                            tick_counter <= 4'd0;
                        end
                    end else begin
                        cycle_counter <= cycle_counter + 1'b1;
                        tick_counter <= tick_counter;
                    end

                    // Update count output:
                    // count = tick_counter - 1 if tick_counter > 0
                    // else count = 0
                    if (tick_counter > 0)
                        count <= tick_counter - 1'b1;
                    else
                        count <= 4'd0;
                end

                DONE: begin
                    counting <= 1'b0;
                    done <= 1'b1;
                    count <= 4'd0;
                    // Hold registers
                    pattern_shift <= pattern_shift;
                    delay_reg <= delay_reg;
                    delay_bits_count <= delay_bits_count;
                    cycle_counter <= 10'd0;
                    tick_counter <= 4'd0;
                end

                default: begin
                    state <= SEARCH;
                    pattern_shift <= 4'd0;
                    delay_reg <= 4'd0;
                    delay_bits_count <= 3'd0;
                    cycle_counter <= 10'd0;
                    tick_counter <= 4'd0;
                    counting <= 1'b0;
                    done <= 1'b0;
                    count <= 4'd0;
                end
            endcase
        end
    end

    // Next state logic
    always @(*) begin
        next_state = state;
        case (state)
            SEARCH: begin
                // Wait for start pattern 1101
                if (pattern_shift == START_PATTERN)
                    next_state = DELAY_LOAD;
                else
                    next_state = SEARCH;
            end

            DELAY_LOAD: begin
                if (delay_bits_count == 3'd4)
                    next_state = COUNT_INIT;
                else
                    next_state = DELAY_LOAD;
            end

            COUNT_INIT: begin
                next_state = COUNT;
            end

            COUNT: begin
                // When tick_counter == 0 and cycle_counter == 999, done counting
                if ((tick_counter == 4'd0) && (cycle_counter == 10'd999))
                    next_state = DONE;
                else
                    next_state = COUNT;
            end

            DONE: begin
                // Wait for ack to restart
                if (ack)
                    next_state = SEARCH;
                else
                    next_state = DONE;
            end

            default: next_state = SEARCH;
        endcase
    end

endmodule