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
    // Shift left, insert new bit at LSB (MSB-first input)
    reg [3:0] pattern_shift;

    // Delay loading register (4 bits)
    // Shift left, insert new bit at LSB (MSB-first)
    reg [3:0] delay_reg;
    reg [2:0] delay_bits_loaded; // counts 0..4

    // Counters for timing
    reg [9:0] cycle_counter;  // counts 0..999 for 1000 cycles per tick
    reg [4:0] tick_counter;   // counts remaining ticks, max 17 (delay+1 max 16+1)

    // For edge detection of state transitions
    reg [1:0] state_d;

    // Synchronous state and register update
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
            state_d <= SEARCH;
        end else begin
            state <= next_state;
            state_d <= state;  // capture previous state

            case(state)
                SEARCH: begin
                    // Shift pattern_shift left, insert new bit at LSB (MSB-first)
                    pattern_shift <= {pattern_shift[2:0], data};
                    delay_bits_loaded <= 3'd0;
                    delay_reg <= delay_reg; // hold
                    cycle_counter <= 10'd0;
                    tick_counter <= 5'd0;
                    counting <= 1'b0;
                    done <= 1'b0;
                    count <= 4'b0;
                end

                DELAY_LOAD: begin
                    // Shift delay_reg left, insert new bit at LSB (MSB-first)
                    delay_reg <= {delay_reg[2:0], data};
                    delay_bits_loaded <= delay_bits_loaded + 1'b1;
                    pattern_shift <= pattern_shift; // hold
                    cycle_counter <= 10'd0;
                    tick_counter <= 5'd0;
                    counting <= 1'b0;
                    done <= 1'b0;
                    count <= 4'b0;
                end

                COUNT: begin
                    pattern_shift <= pattern_shift; // hold
                    delay_reg <= delay_reg;         // hold
                    delay_bits_loaded <= delay_bits_loaded; // hold
                    counting <= 1'b1;
                    done <= 1'b0;

                    // Counting logic
                    if (cycle_counter == 10'd999) begin
                        cycle_counter <= 10'd0;
                        if (tick_counter != 0) begin
                            tick_counter <= tick_counter - 1'b1;
                        end
                    end else begin
                        cycle_counter <= cycle_counter + 1'b1;
                        tick_counter <= tick_counter;
                    end

                    // Output count stable for 1000 cycles, count shows current remaining tick count - 1 
                    // but problem states count output shows delay for first 1000 cycles, delay-1 next 1000, ... down to 0.
                    // So count = tick_counter - 1 (if tick_counter>0), else 0

                    if ((cycle_counter == 10'd999) && (tick_counter != 0)) begin
                        // after decrement of tick_counter
                        count <= tick_counter - 1'b1;
                    end else if (tick_counter != 0) begin
                        count <= tick_counter - 1'b1;
                    end else begin
                        count <= 4'd0;
                    end
                end

                WAIT_ACK: begin
                    // Wait for ack
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
                    // Should not happen
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

            // Initialize tick_counter on transition DELAY_LOAD->COUNT
            if ((state_d == DELAY_LOAD) && (next_state == COUNT)) begin
                // delay_reg holds 4 bits MSB-first loaded
                // tick_counter = delay + 1
                tick_counter <= {1'b0, delay_reg} + 5'd1;
                cycle_counter <= 10'd0;
                // Initialize count to delay value
                count <= delay_reg;
            end
        end
    end

    // Next state logic
    always @(*) begin
        next_state = state;
        case(state)
            SEARCH: begin
                // Detect pattern 1101 in pattern_shift (MSB-first)
                // pattern_shift shifted left, so latest bit at LSB
                // pattern to detect is bits 1101 = binary 4'b1101 = decimal 13
                // Compare pattern_shift to 4'b1101 directly
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
                // When counting done: tick_counter == 0 and cycle_counter == 999 (last cycle completed)
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