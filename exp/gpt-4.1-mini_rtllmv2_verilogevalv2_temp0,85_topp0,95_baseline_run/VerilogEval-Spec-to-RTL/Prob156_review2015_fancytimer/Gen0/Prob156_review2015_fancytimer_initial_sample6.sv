module TopModule (
    input clk,
    input reset,
    input data,
    output reg [3:0] count,
    output reg counting,
    output reg done,
    input ack
);

// States encoding
localparam SEARCH      = 2'd0;
localparam SHIFT_DELAY = 2'd1;
localparam COUNTING    = 2'd2;
localparam DONE        = 2'd3;

reg [1:0] state, next_state;

// Shift register for pattern detection (4 bits)
reg [3:0] pattern_shift;

// Delay register (4 bits)
reg [3:0] delay;

// Bit counter for SHIFT_DELAY state (counts from 0 to 3)
reg [2:0] shift_bit_cnt;

// Cycle counter for counting 1000 cycles per decrement (0 to 999)
reg [9:0] cycle_cnt;

// Remaining countdown value (counts down from delay to 0)
reg [3:0] remaining_count;

// FSM sequential
always @(posedge clk) begin
    if (reset) begin
        state <= SEARCH;
        pattern_shift <= 4'b0000;
        delay <= 4'd0;
        shift_bit_cnt <= 3'd0;
        cycle_cnt <= 10'd0;
        remaining_count <= 4'd0;
        count <= 4'bxxxx; // don't-care
        counting <= 1'b0;
        done <= 1'b0;
    end else begin
        state <= next_state;
        case (state)
            SEARCH: begin
                // Shift in data to pattern_shift
                pattern_shift <= {pattern_shift[2:0], data};
                counting <= 1'b0;
                done <= 1'b0;
                count <= 4'bxxxx; // don't care
            end
            SHIFT_DELAY: begin
                // Shift in delay bits MSB first
                // Use shift_bit_cnt to count 4 bits shifted in
                pattern_shift <= pattern_shift; // hold pattern_shift
                counting <= 1'b0;
                done <= 1'b0;
                // delay bits shifted in MSB first:
                // On each clock, shift delay left by 1, add data at LSB
                delay <= {delay[2:0], data};
            end
            COUNTING: begin
                done <= 1'b0;
                counting <= 1'b1;
                count <= remaining_count;
                // cycle_cnt and remaining_count updated in FSM logic below
            end
            DONE: begin
                counting <= 1'b0;
                done <= 1'b1;
                count <= 4'bxxxx; // don't care
            end
            default: begin
                counting <= 1'b0;
                done <= 1'b0;
                count <= 4'bxxxx;
            end
        endcase
    end
end

// FSM next state and counters logic
always @(*) begin
    // Default next state
    next_state = state;
    // Defaults for counters (updated only when needed)
    // Sequential counters updated in sequential block below
    case (state)
        SEARCH: begin
            // If pattern_shift == 1101, go to SHIFT_DELAY
            if (pattern_shift == 4'b1101)
                next_state = SHIFT_DELAY;
        end
        SHIFT_DELAY: begin
            if (shift_bit_cnt == 3'd3)
                next_state = COUNTING;
        end
        COUNTING: begin
            if ((remaining_count == 4'd0) && (cycle_cnt == 10'd999))
                next_state = DONE;
        end
        DONE: begin
            if (ack)
                next_state = SEARCH;
        end
    endcase
end

// Counters and other sequential logic
always @(posedge clk) begin
    if (reset) begin
        shift_bit_cnt <= 3'd0;
        cycle_cnt <= 10'd0;
        remaining_count <= 4'd0;
        delay <= 4'd0;
        pattern_shift <= 4'b0000;
    end else begin
        case (state)
            SEARCH: begin
                // pattern_shift updated in main sequential block
                shift_bit_cnt <= 3'd0;
                cycle_cnt <= 10'd0;
                remaining_count <= 4'd0;
                delay <= delay;
            end
            SHIFT_DELAY: begin
                // Shift in 1 bit per clock into delay (done in main block)
                if (shift_bit_cnt < 3'd4)
                    shift_bit_cnt <= shift_bit_cnt + 1'b1;
                cycle_cnt <= 10'd0;
                remaining_count <= 4'd0;
            end
            COUNTING: begin
                // cycle_cnt counts from 0 to 999
                if (cycle_cnt == 10'd999) begin
                    cycle_cnt <= 10'd0;
                    if (remaining_count != 4'd0)
                        remaining_count <= remaining_count - 1'b1;
                    else
                        remaining_count <= remaining_count; // remain 0
                end else begin
                    cycle_cnt <= cycle_cnt + 1'b1;
                    remaining_count <= remaining_count;
                end
            end
            DONE: begin
                // Hold counters, no updates
                shift_bit_cnt <= 3'd0;
                cycle_cnt <= 10'd0;
                remaining_count <= 4'd0;
                delay <= delay;
            end
            default: begin
                shift_bit_cnt <= 3'd0;
                cycle_cnt <= 10'd0;
                remaining_count <= 4'd0;
                delay <= delay;
            end
        endcase
    end
end

// Load remaining_count at start of COUNTING state
// We detect rising edge of COUNTING state to load remaining_count = delay
reg state_prev_counting;
always @(posedge clk) begin
    if (reset) begin
        state_prev_counting <= 1'b0;
    end else begin
        state_prev_counting <= (state == COUNTING);
        if ((state == COUNTING) && (state_prev_counting == 1'b0)) begin
            // On rising edge of COUNTING state
            // Initialize remaining_count with delay
            remaining_count <= delay;
            cycle_cnt <= 10'd0;
        end
    end
end

endmodule