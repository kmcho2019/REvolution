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
    // Shift RIGHT, insert new bit at MSB (MSB-first input)
    reg [3:0] pattern_shift;

    // Delay loading register (4 bits)
    // Shift RIGHT, insert new bit at MSB (MSB-first)
    reg [3:0] delay_reg;
    reg [2:0] delay_bits_loaded; // counts 0..4

    // Counters for timing
    reg [9:0] cycle_counter;  // counts 0..999 for 1000 cycles per tick
    reg [4:0] tick_counter;   // counts remaining ticks, max 17 (delay+1 max 16+1)

    // To detect state transitions and initialize counters
    reg state_was_delay_load;

    // Sequential state and register updates
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
            state_was_delay_load <= 1'b0;
        end else begin
            state <= next_state;

            // Remember if previous state was DELAY_LOAD for initialization
            state_was_delay_load <= (state == DELAY_LOAD);

            case(state)
                SEARCH: begin
                    // Shift pattern right, insert new bit at MSB (MSB-first input)
                    pattern_shift <= {data, pattern_shift[3:1]};
                    delay_bits_loaded <= 3'd0;
                    delay_reg <= delay_reg; // hold delay_reg
                    cycle_counter <= 10'd0;
                    tick_counter <= 5'd0;
                    counting <= 1'b0;
                    done <= 1'b0;
                    count <= 4'bx; // don't care when not counting
                end

                DELAY_LOAD: begin
                    // Shift delay_reg right, insert new bit at MSB (MSB-first)
                    delay_reg <= {data, delay_reg[3:1]};
                    delay_bits_loaded <= delay_bits_loaded + 1'b1;
                    pattern_shift <= pattern_shift; // hold
                    cycle_counter <= 10'd0;
                    tick_counter <= 5'd0;
                    counting <= 1'b0;
                    done <= 1'b0;
                    count <= 4'bx; // don't care
                end

                COUNT: begin
                    pattern_shift <= pattern_shift; // hold
                    delay_reg <= delay_reg;         // hold
                    delay_bits_loaded <= delay_bits_loaded; // hold
                    counting <= 1'b1;
                    done <= 1'b0;

                    // On first cycle entering COUNT, initialize counters
                    // Use state_was_delay_load to detect transition
                    if (state_was_delay_load && (next_state == COUNT)) begin
                        // Initialize counters and outputs
                        cycle_counter <= 10'd0;
                        tick_counter <= {1'b0, delay_reg} + 5'd1; // delay+1 ticks
                        count <= delay_reg;
                    end else begin
                        // Normal counting
                        if (cycle_counter == 10'd999) begin
                            cycle_counter <= 10'd0;
                            if (tick_counter != 0) begin
                                tick_counter <= tick_counter - 1'b1;
                                // Update count to one less than previous tick_counter
                                count <= (tick_counter > 1) ? (tick_counter - 1'b1 - 1'b1) : 4'd0;
                                // Explanation:
                                // tick_counter decremented at cycle 999,
                                // count reflects remaining ticks-1 stable during the 1000 cycles.
                                // When tick_counter reaches 1, count will be 0.
                            end else begin
                                tick_counter <= 0;
                                count <= 4'd0;
                            end
                        end else begin
                            cycle_counter <= cycle_counter + 1'b1;
                            // count remains stable during the 1000 cycles
                            // keep count as is
                        end
                    end
                end

                WAIT_ACK: begin
                    pattern_shift <= 4'b0;
                    delay_reg <= 4'b0;
                    delay_bits_loaded <= 3'd0;
                    cycle_counter <= 10'd0;
                    tick_counter <= 5'd0;
                    counting <= 1'b0;
                    done <= 1'b1;
                    count <= 4'bx; // don't care
                end

                default: begin
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

    // Next state combinational logic
    always @(*) begin
        next_state = state;
        case(state)
            SEARCH: begin
                // Pattern to detect: 4'b1101, with pattern_shift bits ordered as MSB oldest bit, LSB newest bit
                // We shift right, inserting new bit at MSB; thus pattern is aligned MSB first in pattern_shift.
                // Compare directly
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
                // Counting done when tick_counter == 0 and cycle_counter == 999 (end of last tick)
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