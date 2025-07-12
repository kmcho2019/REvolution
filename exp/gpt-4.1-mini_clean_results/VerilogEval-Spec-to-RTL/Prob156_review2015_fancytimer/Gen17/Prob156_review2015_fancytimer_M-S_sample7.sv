module TopModule (
    input        clk,
    input        reset,   // synchronous active high
    input        data,
    output reg [3:0] count,
    output reg   counting,
    output reg   done,
    input        ack
);

    // FSM states
    typedef enum logic [1:0] {
        SEARCH     = 2'd0,
        DELAY_LOAD = 2'd1,
        COUNT      = 2'd2,
        WAIT_ACK   = 2'd3
    } state_t;

    state_t state, next_state;

    // Shift registers for pattern and delay
    reg [3:0] pattern_shift;
    reg [3:0] delay_reg;
    reg [2:0] delay_bits_loaded; // 0..4

    // Counters for timing
    reg [9:0] cycle_counter;    // 0..999 (1000 cycles per tick)
    reg [3:0] tick_counter;     // delay down to 0

    // Pattern to detect: 4'b1101
    localparam [3:0] START_PATTERN = 4'b1101;

    // Sequential logic: state and registers update
    always @(posedge clk) begin
        if (reset) begin
            state <= SEARCH;
            pattern_shift <= 4'd0;
            delay_reg <= 4'd0;
            delay_bits_loaded <= 3'd0;
            cycle_counter <= 10'd0;
            tick_counter <= 4'd0;
            count <= 4'd0;
            counting <= 1'b0;
            done <= 1'b0;
        end else begin
            state <= next_state;

            case (state)
                SEARCH: begin
                    // Shift left, insert new bit at LSB (MSB-first input)
                    pattern_shift <= {pattern_shift[2:0], data};
                    delay_bits_loaded <= 3'd0;
                    delay_reg <= 4'd0;
                    cycle_counter <= 10'd0;
                    tick_counter <= 4'd0;
                    count <= 4'd0;
                    counting <= 1'b0;
                    done <= 1'b0;
                end

                DELAY_LOAD: begin
                    // Shift in delay bits MSB-first: shift left, new bit at LSB
                    delay_reg <= {delay_reg[2:0], data};
                    delay_bits_loaded <= delay_bits_loaded + 1'b1;
                    pattern_shift <= pattern_shift;
                    cycle_counter <= 10'd0;
                    tick_counter <= 4'd0;
                    count <= 4'd0;
                    counting <= 1'b0;
                    done <= 1'b0;
                end

                COUNT: begin
                    counting <= 1'b1;
                    done <= 1'b0;

                    if (cycle_counter == 10'd999) begin
                        cycle_counter <= 10'd0;
                        if (tick_counter != 0)
                            tick_counter <= tick_counter - 1'b1;
                    end else begin
                        cycle_counter <= cycle_counter + 1'b1;
                        tick_counter <= tick_counter;
                    end

                    // count output = current tick value
                    // It starts at delay_reg, stable for 1000 cycles per tick
                    count <= tick_counter;
                end

                WAIT_ACK: begin
                    counting <= 1'b0;
                    done <= 1'b1;
                    pattern_shift <= 4'd0;
                    delay_reg <= 4'd0;
                    delay_bits_loaded <= 3'd0;
                    cycle_counter <= 10'd0;
                    tick_counter <= 4'd0;
                    count <= 4'd0;
                end

                default: begin
                    state <= SEARCH;
                    pattern_shift <= 4'd0;
                    delay_reg <= 4'd0;
                    delay_bits_loaded <= 3'd0;
                    cycle_counter <= 10'd0;
                    tick_counter <= 4'd0;
                    count <= 4'd0;
                    counting <= 1'b0;
                    done <= 1'b0;
                end
            endcase
        end
    end

    // Combinational next-state logic
    always @(*) begin
        next_state = state;
        case (state)
            SEARCH: begin
                if (pattern_shift == START_PATTERN)
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
                // Counting done when tick_counter == 0 and cycle_counter == 999
                if (tick_counter == 0 && cycle_counter == 10'd999)
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

    // On entering COUNT state, initialize tick_counter to delay + 1
    always @(posedge clk) begin
        if (reset) begin
            // handled above
        end else if (state != COUNT && next_state == COUNT) begin
            tick_counter <= delay_reg + 1'b1; // delay + 1 ticks
            cycle_counter <= 10'd0;
        end
    end

endmodule