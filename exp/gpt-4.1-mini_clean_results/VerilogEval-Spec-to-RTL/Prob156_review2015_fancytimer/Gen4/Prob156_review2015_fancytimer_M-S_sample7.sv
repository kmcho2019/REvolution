module TopModule (
    input        clk,
    input        reset,  // synchronous active-high reset
    input        data,
    output reg [3:0] count,
    output reg       counting,
    output reg       done,
    input        ack
);

    // FSM States
    localparam SEARCH     = 2'd0;
    localparam LOAD_DELAY = 2'd1;
    localparam COUNTING   = 2'd2;
    localparam DONE       = 2'd3;

    reg [1:0] state, next_state;

    // Pattern detection shift register (for 1101)
    reg [3:0] pattern_shift;

    // Delay shift register and bit count for loading 4 bits
    reg [3:0] delay_reg;
    reg [2:0] delay_bit_count;

    // Counters for timing
    reg [9:0] cycle_counter;   // 0..999 counts clock cycles in one tick
    reg [3:0] tick_counter;    // counts remaining ticks (delay down to 0)

    // Detect start pattern 1101
    wire pattern_match = (pattern_shift == 4'b1101);

    // FSM next state logic
    always @(*) begin
        case(state)
            SEARCH:
                if (pattern_match)
                    next_state = LOAD_DELAY;
                else
                    next_state = SEARCH;

            LOAD_DELAY:
                if (delay_bit_count == 4)
                    next_state = COUNTING;
                else
                    next_state = LOAD_DELAY;

            COUNTING:
                // Move to DONE after finishing last tick (tick_counter=0 and cycle_counter=999)
                if ((tick_counter == 0) && (cycle_counter == 10'd999))
                    next_state = DONE;
                else
                    next_state = COUNTING;

            DONE:
                if (ack)
                    next_state = SEARCH;
                else
                    next_state = DONE;

            default:
                next_state = SEARCH;
        endcase
    end

    // Sequential logic
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
                    // Shift in bits continuously to detect pattern
                    pattern_shift <= {pattern_shift[2:0], data};
                    // Reset delay loading
                    delay_reg <= 4'b0;
                    delay_bit_count <= 3'd0;
                    // Reset counters
                    cycle_counter <= 10'd0;
                    tick_counter <= 4'd0;
                    // Outputs
                    counting <= 1'b0;
                    done <= 1'b0;
                    count <= 4'd0;
                end

                LOAD_DELAY: begin
                    // Shift in delay bits MSB first: shift left and insert at LSB
                    delay_reg <= {delay_reg[2:0], data};
                    delay_bit_count <= delay_bit_count + 1'b1;
                    // Pattern shift hold (no update)
                    pattern_shift <= pattern_shift;
                    // Outputs inactive
                    counting <= 1'b0;
                    done <= 1'b0;
                    count <= 4'd0;
                    // Counters stay reset
                    cycle_counter <= 10'd0;
                    tick_counter <= 4'd0;
                end

                COUNTING: begin
                    // Pattern shift hold
                    pattern_shift <= pattern_shift;

                    counting <= 1'b1;
                    done <= 1'b0;

                    // Output remaining ticks as count
                    count <= tick_counter;

                    // Cycle counter increments
                    if (cycle_counter == 10'd999) begin
                        cycle_counter <= 10'd0;
                        if (tick_counter != 0)
                            tick_counter <= tick_counter - 1'b1;
                        // if tick_counter==0, counting done next cycle
                    end else begin
                        cycle_counter <= cycle_counter + 1'b1;
                    end
                end

                DONE: begin
                    // Pattern shift hold
                    pattern_shift <= pattern_shift;

                    counting <= 1'b0;
                    done <= 1'b1;
                    count <= 4'd0;

                    // Reset delay loading and counters until ack
                    delay_reg <= delay_reg;
                    delay_bit_count <= 3'd0;
                    cycle_counter <= 10'd0;
                    tick_counter <= 4'd0;
                end

                default: begin
                    // Safety fallback: go to SEARCH
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

            // Load tick_counter = delay at transition from LOAD_DELAY to COUNTING
            if (state == LOAD_DELAY && next_state == COUNTING) begin
                tick_counter <= delay_reg;
                cycle_counter <= 10'd0;
            end
        end
    end

endmodule