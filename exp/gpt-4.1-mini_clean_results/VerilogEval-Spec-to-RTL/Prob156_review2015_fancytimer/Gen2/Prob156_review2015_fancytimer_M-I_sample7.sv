module TopModule(
    input clk,
    input reset,    // synchronous active high
    input data,
    output reg [3:0] count,
    output reg counting,
    output reg done,
    input ack
);

// FSM states
localparam SEARCH     = 2'd0;
localparam LOAD_DELAY = 2'd1;
localparam COUNT      = 2'd2;
localparam DONE       = 2'd3;

reg [1:0] state, next_state;

// For pattern detection 1101 (4 bits)
reg [3:0] pattern_shift;

// For delay loading (4 bits, MSB first)
reg [3:0] delay_reg;
reg [2:0] load_bit_count;  // counts 0 to 4

// Counters for timing the counting phase:
// cycle_count_1000 counts 0..999 clock cycles in each 1-delay step
reg [9:0] cycle_count_1000; // 10 bits for 0 to 999

// remaining_delay counts down delay steps from delay_reg down to 0
reg [3:0] remaining_delay;

// FSM sequential logic
always @(posedge clk) begin
    if (reset) begin
        state <= SEARCH;
        pattern_shift <= 4'b0000;
        delay_reg <= 4'b0000;
        load_bit_count <= 3'd0;
        cycle_count_1000 <= 10'd0;
        remaining_delay <= 4'd0;
        count <= 4'b0000;
        counting <= 1'b0;
        done <= 1'b0;
    end else begin
        state <= next_state;

        case(state)
            SEARCH: begin
                // Shift in data for pattern detection
                pattern_shift <= {pattern_shift[2:0], data};
                // Clear delay loading registers and counters
                delay_reg <= 4'b0000;
                load_bit_count <= 3'd0;
                cycle_count_1000 <= 10'd0;
                remaining_delay <= 4'd0;
                count <= 4'b0000;
                counting <= 1'b0;
                done <= 1'b0;
            end

            LOAD_DELAY: begin
                // Shift in delay bits MSB first (delay_reg[3] first, then down to [0])
                delay_reg <= {delay_reg[2:0], data};
                load_bit_count <= load_bit_count + 1'b1;
                // Reset counters for counting phase
                cycle_count_1000 <= 10'd0;
                remaining_delay <= 4'd0;
                count <= 4'b0000;
                counting <= 1'b0;
                done <= 1'b0;
                pattern_shift <= pattern_shift; // hold pattern_shift stable (could also clear)
            end

            COUNT: begin
                counting <= 1'b1;
                done <= 1'b0;
                // Hold pattern_shift and delay_reg stable
                pattern_shift <= pattern_shift;
                delay_reg <= delay_reg;
                load_bit_count <= load_bit_count;

                // Cycle counter counts 0 to 999
                if (cycle_count_1000 == 10'd999) begin
                    cycle_count_1000 <= 10'd0;
                    // Decrement remaining_delay at the end of each 1000-cycle interval if > 0
                    if (remaining_delay != 4'd0)
                        remaining_delay <= remaining_delay - 1'b1;
                    // else remain at zero until done state transitions
                end else begin
                    cycle_count_1000 <= cycle_count_1000 + 1'b1;
                    remaining_delay <= remaining_delay; // hold
                end

                // Output count = current remaining_delay value
                count <= remaining_delay;
            end

            DONE: begin
                done <= 1'b1;
                counting <= 1'b0;
                count <= 4'b0000; // don't-care
                pattern_shift <= pattern_shift;
                delay_reg <= delay_reg;
                load_bit_count <= 3'd0;
                cycle_count_1000 <= 10'd0;
                remaining_delay <= 4'd0;
            end

            default: begin
                // Defensive reset to SEARCH state
                state <= SEARCH;
                pattern_shift <= 4'b0000;
                delay_reg <= 4'b0000;
                load_bit_count <= 3'd0;
                cycle_count_1000 <= 10'd0;
                remaining_delay <= 4'd0;
                count <= 4'b0000;
                counting <= 1'b0;
                done <= 1'b0;
            end
        endcase

        // When entering COUNT state, initialize counting variables
        if (state != COUNT && next_state == COUNT) begin
            // Start counting: remaining_delay set to delay_reg
            remaining_delay <= delay_reg;
            cycle_count_1000 <= 10'd0;
            count <= delay_reg;
        end
    end
end

// FSM combinational next state logic
always @(*) begin
    next_state = state;
    case(state)
        SEARCH: begin
            // Transition to LOAD_DELAY if pattern detected (pattern_shift == 1101)
            if (pattern_shift == 4'b1101)
                next_state = LOAD_DELAY;
            else
                next_state = SEARCH;
        end

        LOAD_DELAY: begin
            // After loading 4 bits, go to COUNT
            if (load_bit_count == 3'd4)
                next_state = COUNT;
            else
                next_state = LOAD_DELAY;
        end

        COUNT: begin
            // Counting finishes when remaining_delay = 0 AND cycle_count_1000 = 999
            // Because that completes the last 1000 cycle interval
            if ((remaining_delay == 4'd0) && (cycle_count_1000 == 10'd999))
                next_state = DONE;
            else
                next_state = COUNT;
        end

        DONE: begin
            // Wait for ack to return to SEARCH
            if (ack)
                next_state = SEARCH;
            else
                next_state = DONE;
        end

        default: next_state = SEARCH;
    endcase
end

endmodule