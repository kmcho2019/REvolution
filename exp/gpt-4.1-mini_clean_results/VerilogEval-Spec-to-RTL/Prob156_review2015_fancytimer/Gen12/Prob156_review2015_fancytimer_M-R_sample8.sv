module TopModule(
    input  wire       clk,
    input  wire       reset,   // synchronous active-high
    input  wire       data,
    output reg [3:0]  count,
    output reg        counting,
    output reg        done,
    input  wire       ack
);

    // State encoding
    localparam SEARCH        = 2'b00;
    localparam LOAD_DELAY    = 2'b01;
    localparam COUNT         = 2'b10;
    localparam DONE_WAIT_ACK = 2'b11;

    reg [1:0] state, next_state;

    // Pattern detector shift register
    reg [3:0] shift_reg;

    // Delay bits loaded MSB first
    reg [3:0] delay_reg;
    reg [2:0] delay_bit_cnt;  // counts 0..3 bits loaded

    // Segment count = number of 1000-cycle segments left
    // Initially delay_reg (NOT delay_reg+1) to fix off-by-one
    reg [3:0] segment_count;

    // 0..999 cycle counter within current segment
    reg [9:0] cycle_counter;

    // Pattern found when shift_reg == 4'b1101
    wire pattern_found = (shift_reg == 4'b1101);

    // State register with synchronous reset
    always @(posedge clk) begin
        if (reset)
            state <= SEARCH;
        else
            state <= next_state;
    end

    // Shift register update in SEARCH state only
    always @(posedge clk) begin
        if (reset)
            shift_reg <= 4'b0000;
        else if (state == SEARCH)
            shift_reg <= {shift_reg[2:0], data};
        else
            shift_reg <= shift_reg;  // hold
    end

    // Delay bit counter and delay register loading
    always @(posedge clk) begin
        if (reset) begin
            delay_bit_cnt <= 3'd0;
            delay_reg <= 4'd0;
        end else if (state == LOAD_DELAY) begin
            // Shift delay_reg left and insert new data bit at LSB
            delay_reg <= {delay_reg[2:0], data};
            delay_bit_cnt <= delay_bit_cnt + 1'b1;
        end else begin
            delay_bit_cnt <= 3'd0;
            delay_reg <= delay_reg;  // hold delay_reg when not loading
        end
    end

    // cycle_counter counts 0..999 within each segment
    always @(posedge clk) begin
        if (reset)
            cycle_counter <= 10'd0;
        else if (state == COUNT) begin
            if (cycle_counter == 10'd999)
                cycle_counter <= 10'd0;
            else
                cycle_counter <= cycle_counter + 1'b1;
        end else
            cycle_counter <= 10'd0;
    end

    // segment_count loading and decrementing logic
    always @(posedge clk) begin
        if (reset)
            segment_count <= 4'd0;
        else if (state == LOAD_DELAY && delay_bit_cnt == 3'd4) begin
            // Load segment_count to delay_reg (NOT delay_reg+1)
            segment_count <= delay_reg;
        end else if (state == COUNT && cycle_counter == 10'd999 && segment_count != 0) begin
            segment_count <= segment_count - 1'b1;
        end else
            segment_count <= segment_count;  // hold
    end

    // Next state logic combinational
    always @(*) begin
        next_state = state;
        case(state)
            SEARCH: begin
                if (pattern_found)
                    next_state = LOAD_DELAY;
            end
            LOAD_DELAY: begin
                if (delay_bit_cnt == 3'd4)
                    next_state = COUNT;
            end
            COUNT: begin
                // When last segment finished (segment_count == 0 after cycle ends)
                if ((segment_count == 4'd0) && (cycle_counter == 10'd999))
                    next_state = DONE_WAIT_ACK;
            end
            DONE_WAIT_ACK: begin
                if (ack)
                    next_state = SEARCH;
            end
        endcase
    end

    // Outputs logic: combinational based on current state and counters
    always @(*) begin
        counting = 1'b0;
        done = 1'b0;
        count = 4'd0; // default don't-care stable value

        case(state)
            SEARCH: begin
                counting = 1'b0;
                done = 1'b0;
                count = 4'd0;  // don't care stable
            end
            LOAD_DELAY: begin
                counting = 1'b0;
                done = 1'b0;
                count = 4'd0;  // don't care stable
            end
            COUNT: begin
                counting = 1'b1;
                done = 1'b0;

                // Output the remaining time value as requested:
                // Output count is the delay value counting down,
                // show the current segment_count minus 1 because segment_count counts down from delay,
                // but count output should be delay for 1000 cycles, then delay-1, etc.
                // When segment_count>0, count = segment_count-1;
                // When segment_count==0 (last segment), count = 0
                if (segment_count == 0)
                    count = 4'd0;
                else
                    count = segment_count - 1'b1;
            end
            DONE_WAIT_ACK: begin
                counting = 1'b0;
                done = 1'b1;
                count = 4'd0;  // don't care stable
            end
            default: begin
                counting = 1'b0;
                done = 1'b0;
                count = 4'd0;
            end
        endcase
    end

endmodule