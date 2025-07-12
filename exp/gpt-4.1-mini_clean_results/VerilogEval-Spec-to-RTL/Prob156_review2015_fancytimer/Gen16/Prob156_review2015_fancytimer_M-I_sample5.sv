module TopModule (
    input         clk,
    input         reset,   // synchronous active high
    input         data,
    output reg [3:0] count,
    output reg    counting,
    output reg    done,
    input         ack
);

    // FSM states
    localparam SEARCH     = 2'd0;
    localparam DELAY_LOAD = 2'd1;
    localparam COUNT      = 2'd2;
    localparam WAIT_ACK   = 2'd3;

    reg [1:0] state, next_state;

    // Pattern detection shift register (4 bits)
    // Shift right, insert new bit at MSB (MSB-first input)
    reg [3:0] pattern_shift;

    // Delay loading register (4 bits)
    // Shift right, insert new bit at MSB (MSB-first)
    reg [3:0] delay_reg;
    reg [2:0] delay_bits_loaded; // counts 0..4

    // Counters for timing
    reg [9:0] cycle_counter;  // counts 0..999 for 1000 cycles per tick
    reg [4:0] tick_counter;   // counts remaining ticks (delay+1 max 17)

    reg entered_count_state; // flag for first cycle in COUNT

    // Sequential logic: state update and registers
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
            entered_count_state <= 1'b0;
        end else begin
            state <= next_state;

            case(state)
                SEARCH: begin
                    // Shift right, insert new bit at MSB to keep MSB-first order
                    pattern_shift <= {data, pattern_shift[3:1]};
                    delay_bits_loaded <= 3'd0;
                    delay_reg <= delay_reg; // hold
                    cycle_counter <= 10'd0;
                    tick_counter <= 5'd0;
                    counting <= 1'b0;
                    done <= 1'b0;
                    count <= 4'b0;
                    entered_count_state <= 1'b0;
                end

                DELAY_LOAD: begin
                    // Shift right, insert new bit at MSB
                    delay_reg <= {data, delay_reg[3:1]};
                    delay_bits_loaded <= delay_bits_loaded + 1'b1;
                    pattern_shift <= pattern_shift; // hold
                    cycle_counter <= 10'd0;
                    tick_counter <= 5'd0;
                    counting <= 1'b0;
                    done <= 1'b0;
                    count <= 4'b0;
                    entered_count_state <= 1'b0;
                end

                COUNT: begin
                    pattern_shift <= pattern_shift; // hold
                    delay_reg <= delay_reg;         // hold
                    delay_bits_loaded <= delay_bits_loaded; // hold
                    counting <= 1'b1;
                    done <= 1'b0;

                    if (!entered_count_state) begin
                        // First cycle in COUNT state: initialize counters
                        cycle_counter <= 10'd0;
                        tick_counter <= {1'b0, delay_reg} + 5'd1; // delay + 1
                        count <= delay_reg;
                        entered_count_state <= 1'b1;
                    end else begin
                        if (cycle_counter == 10'd999) begin
                            cycle_counter <= 10'd0;

                            // Decrement tick_counter if > 0
                            if (tick_counter != 0) begin
                                tick_counter <= tick_counter - 1'b1;
                                // Update count output after decrement for next 1000 cycles
                                // When tick_counter decrements from N to N-1, count should output N-1
                                if (tick_counter > 1)
                                    count <= tick_counter - 1'b1;
                                else
                                    count <= 4'd0; // last tick is zero
                            end else begin
                                // tick_counter == 0, counting done, count=0 stable
                                count <= 4'd0;
                            end
                        end else begin
                            // count stable during 1000 cycles
                            count <= count;
                            cycle_counter <= cycle_counter + 1'b1;
                            tick_counter <= tick_counter;
                        end
                    end
                end

                WAIT_ACK: begin
                    // Waiting for ack; outputs stable
                    pattern_shift <= 4'b0;
                    delay_reg <= 4'b0;
                    delay_bits_loaded <= 3'd0;
                    cycle_counter <= 10'd0;
                    tick_counter <= 5'd0;
                    counting <= 1'b0;
                    done <= 1'b1;
                    count <= 4'b0;
                    entered_count_state <= 1'b0;
                end

                default: begin
                    // Should never happen
                    state <= SEARCH;
                    pattern_shift <= 4'b0;
                    delay_reg <= 4'b0;
                    delay_bits_loaded <= 3'd0;
                    cycle_counter <= 10'd0;
                    tick_counter <= 5'd0;
                    counting <= 1'b0;
                    done <= 1'b0;
                    count <= 4'b0;
                    entered_count_state <= 1'b0;
                end
            endcase
        end
    end

    // Combinational next-state logic
    always @(*) begin
        next_state = state;
        case(state)
            SEARCH: begin
                // Detect pattern 1101 (MSB-first) in pattern_shift shifted right
                // pattern_shift holds bits with newest at MSB
                // pattern to detect: 4'b1101
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
                // When tick_counter == 0 and cycle_counter == 999, counting complete
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