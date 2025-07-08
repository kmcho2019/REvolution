module TopModule (
    input clk,
    input reset,
    input data,
    output reg [3:0] count,
    output reg counting,
    output reg done,
    input ack
);

// FSM states
localparam SEARCH      = 2'd0;
localparam SHIFT_DELAY = 2'd1;
localparam COUNTING    = 2'd2;
localparam DONE_STATE  = 2'd3;

reg [1:0] state, next_state;

// Shift register for detecting 1101 pattern
reg [3:0] pattern_shift;

// Delay register (4 bits)
reg [3:0] delay_reg;

// Shift count for delay bits shifted in (0 to 4)
reg [2:0] shift_cnt;

// Cycle counter for counting 1000 clock cycles per unit delay
reg [9:0] cycle_counter; // counts from 0 to 999

// Remaining delay count (counts down from delay_reg to 0)
reg [3:0] remaining_delay;

always @(posedge clk) begin
    if (reset) begin
        state <= SEARCH;
        pattern_shift <= 4'd0;
        delay_reg <= 4'd0;
        shift_cnt <= 3'd0;
        cycle_counter <= 10'd0;
        remaining_delay <= 4'd0;
        counting <= 1'b0;
        done <= 1'b0;
        count <= 4'b0000;
    end else begin
        state <= next_state;

        case (state)
            SEARCH: begin
                // Shift in data bit into pattern_shift
                pattern_shift <= {pattern_shift[2:0], data};
                counting <= 1'b0;
                done <= 1'b0;
                count <= 4'b0000; // don't care, hold zero here
                delay_reg <= delay_reg;
                shift_cnt <= 3'd0;
                cycle_counter <= 10'd0;
                remaining_delay <= 4'd0;
            end

            SHIFT_DELAY: begin
                // Shift in delay bits MSB first
                delay_reg <= {delay_reg[2:0], data};
                shift_cnt <= shift_cnt + 1'b1;
                counting <= 1'b0;
                done <= 1'b0;
                count <= 4'b0000; // don't care while shifting delay
            end

            COUNTING: begin
                counting <= 1'b1;
                done <= 1'b0;
                // count output is remaining_delay
                count <= remaining_delay;

                if (cycle_counter == 10'd999) begin
                    cycle_counter <= 10'd0;
                    if (remaining_delay != 0) begin
                        remaining_delay <= remaining_delay - 1'b1;
                    end else begin
                        // Counting finished, will move to done in next_state logic
                        remaining_delay <= remaining_delay;
                    end
                end else begin
                    cycle_counter <= cycle_counter + 1'b1;
                end
            end

            DONE_STATE: begin
                counting <= 1'b0;
                done <= 1'b1;
                count <= 4'b0000; // don't care
                // waiting for ack to go back to SEARCH
            end

            default: begin
                // Should not happen, default to SEARCH
                counting <= 1'b0;
                done <= 1'b0;
                count <= 4'b0000;
            end
        endcase
    end
end

// Next state logic
always @(*) begin
    next_state = state;

    case (state)
        SEARCH: begin
            // Detect pattern 1101
            // pattern_shift contains the last 4 bits shifted in
            // If pattern_shift == 4'b1101, start shift delay
            if (pattern_shift == 4'b1101)
                next_state = SHIFT_DELAY;
            else
                next_state = SEARCH;
        end

        SHIFT_DELAY: begin
            if (shift_cnt == 3'd4)
                next_state = COUNTING;
            else
                next_state = SHIFT_DELAY;
        end

        COUNTING: begin
            // Wait until counting finishes ((delay+1)*1000 cycles)
            // counting ends when remaining_delay==0 and cycle_counter==999
            if (remaining_delay == 0 && cycle_counter == 10'd999)
                next_state = DONE_STATE;
            else
                next_state = COUNTING;
        end

        DONE_STATE: begin
            // Wait for ack==1 to go back to SEARCH
            if (ack)
                next_state = SEARCH;
            else
                next_state = DONE_STATE;
        end

        default: next_state = SEARCH;
    endcase
end

// Initialize delay and counters at start of counting state
always @(posedge clk) begin
    if (reset) begin
        // already handled in main always block
    end else begin
        if (state == SHIFT_DELAY && next_state == COUNTING) begin
            // Just finished shifting delay bits, set remaining_delay and counters
            remaining_delay <= delay_reg;
            cycle_counter <= 10'd0;
            count <= delay_reg;
        end
    end
end

endmodule