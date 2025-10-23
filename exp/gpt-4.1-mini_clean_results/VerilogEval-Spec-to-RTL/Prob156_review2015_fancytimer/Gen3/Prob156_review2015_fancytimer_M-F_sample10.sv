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
reg [2:0] load_bit_count;  // counts 0..3 for 4 bits

// Counters for timing the counting phase:
// cycle_count_1000 counts 0..999 clock cycles in each 1-delay step
reg [9:0] cycle_count_1000; // 10 bits for 0..999

// remaining_delay counts down delay steps from delay_reg down to 0
reg [3:0] remaining_delay;

// Sequential logic
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

        case (state)
            SEARCH: begin
                // Shift in data for pattern detection
                pattern_shift <= {pattern_shift[2:0], data};

                // Clear other regs during SEARCH
                delay_reg <= 4'b0000;
                load_bit_count <= 3'd0;
                cycle_count_1000 <= 10'd0;
                remaining_delay <= 4'd0;
                count <= 4'b0000;
                counting <= 1'b0;
                done <= 1'b0;
            end

            LOAD_DELAY: begin
                // Shift delay bits MSB first, shift left and add data bit as LSB
                delay_reg <= {delay_reg[2:0], data};
                load_bit_count <= load_bit_count + 1'b1;

                // Keep other signals cleared
                cycle_count_1000 <= 10'd0;
                remaining_delay <= 4'd0;
                count <= 4'b0000;
                counting <= 1'b0;
                done <= 1'b0;
                pattern_shift <= pattern_shift; // hold pattern_shift stable
            end

            COUNT: begin
                counting <= 1'b1;
                done <= 1'b0;

                // On first cycle entering COUNT, remaining_delay and cycle_count_1000 are initialized (see after case)

                // Output current remaining_delay as count
                count <= remaining_delay;

                // Count cycles 0..999
                if (cycle_count_1000 == 10'd999) begin
                    cycle_count_1000 <= 10'd0;
                    // Decrement remaining_delay if >0
                    if (remaining_delay != 4'd0)
                        remaining_delay <= remaining_delay - 1'b1;
                    else
                        remaining_delay <= remaining_delay; // hold at zero
                end else begin
                    cycle_count_1000 <= cycle_count_1000 + 1'b1;
                end

                // pattern_shift, delay_reg and load_bit_count held stable
                pattern_shift <= pattern_shift;
                delay_reg <= delay_reg;
                load_bit_count <= load_bit_count;
            end

            DONE: begin
                done <= 1'b1;
                counting <= 1'b0;
                count <= 4'bxxxx; // don't care

                // Clear registers except pattern_shift (could be held or cleared)
                delay_reg <= 4'b0000;
                load_bit_count <= 3'd0;
                cycle_count_1000 <= 10'd0;
                remaining_delay <= 4'd0;
                pattern_shift <= pattern_shift; // hold or clear as desired
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

        // Initialize remaining_delay and cycle_count_1000 when entering COUNT state
        // Detect rising edge into COUNT (prev != COUNT and next == COUNT)
        if ((state != COUNT) && (next_state == COUNT)) begin
            remaining_delay <= delay_reg;
            cycle_count_1000 <= 10'd0;
            count <= delay_reg;
        end
    end
end

// Combinational next state logic
always @(*) begin
    next_state = state;
    case (state)
        SEARCH: begin
            // Detect pattern 1101 in pattern_shift to enter LOAD_DELAY
            if (pattern_shift == 4'b1101)
                next_state = LOAD_DELAY;
            else
                next_state = SEARCH;
        end

        LOAD_DELAY: begin
            // After loading 4 bits (load_bit_count 0..3), move to COUNT
            if (load_bit_count == 3'd4)
                next_state = COUNT;
            else
                next_state = LOAD_DELAY;
        end

        COUNT: begin
            // Finish when remaining_delay == 0 and cycle_count_1000 == 999
            if ((remaining_delay == 4'd0) && (cycle_count_1000 == 10'd999))
                next_state = DONE;
            else
                next_state = COUNT;
        end

        DONE: begin
            // Wait for ack to go back to SEARCH
            if (ack)
                next_state = SEARCH;
            else
                next_state = DONE;
        end

        default: next_state = SEARCH;
    endcase
end

endmodule