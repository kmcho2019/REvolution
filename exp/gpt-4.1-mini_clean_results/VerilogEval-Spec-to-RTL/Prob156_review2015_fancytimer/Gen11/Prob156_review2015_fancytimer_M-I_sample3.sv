module TopModule (
    input  wire       clk,
    input  wire       reset,  // synchronous active-high reset
    input  wire       data,
    output reg [3:0]  count,
    output reg        counting,
    output reg        done,
    input  wire       ack
);

    // FSM states
    typedef enum reg [1:0] {
        SEARCH       = 2'b00,
        LOAD_DELAY   = 2'b01,
        COUNT        = 2'b10,
        DONE_WAIT_ACK= 2'b11
    } state_t;

    reg [1:0] state, state_next;

    // Shift register for pattern detection (4 bits)
    reg [3:0] pattern_shift;

    // Delay loading registers
    reg [3:0] delay_reg;
    reg [2:0] delay_bit_cnt; // counts 0..4

    // Cycle counter within each 1000 cycle segment (0..999)
    reg [9:0] cycle_counter;

    // Segment count (counts down from delay+1 to 0)
    reg [3:0] segment_count;

    // Pattern detected when shift register equals 1101
    wire pattern_found = (pattern_shift == 4'b1101);

    // FSM sequential logic
    always @(posedge clk) begin
        if (reset)
            state <= SEARCH;
        else
            state <= state_next;
    end

    // Pattern shift register: shift in data every clk in SEARCH state
    always @(posedge clk) begin
        if (reset)
            pattern_shift <= 4'b0000;
        else if (state == SEARCH)
            pattern_shift <= {pattern_shift[2:0], data};
    end

    // Delay loading: MSB first means first bit loaded goes to MSB (bit 3)
    // We'll shift left and insert new bit at LSB
    always @(posedge clk) begin
        if (reset) begin
            delay_reg <= 4'b0000;
            delay_bit_cnt <= 3'd0;
        end else if (state == LOAD_DELAY) begin
            delay_reg <= {delay_reg[2:0], data};
            delay_bit_cnt <= delay_bit_cnt + 1'b1;
        end else if (state == SEARCH) begin
            delay_reg <= 4'b0000;
            delay_bit_cnt <= 3'd0;
        end
    end

    // Cycle counter for counting clock cycles within current 1000 cycle segment
    always @(posedge clk) begin
        if (reset)
            cycle_counter <= 10'd0;
        else if (state == COUNT) begin
            if (cycle_counter == 10'd999)
                cycle_counter <= 10'd0;
            else
                cycle_counter <= cycle_counter + 1'b1;
        end else begin
            cycle_counter <= 10'd0;
        end
    end

    // Segment count: 
    // - Loaded once after delay bits are fully loaded: segment_count = delay_reg + 1
    // - Decremented by 1 at end of each 1000 cycle segment (cycle_counter == 999)
    // Use a flag load_segment to load segment_count exactly once after delay loading completes
    reg load_segment;

    always @(posedge clk) begin
        if (reset)
            load_segment <= 1'b0;
        else
            // load_segment pulse when delay_bit_cnt reaches 4 (done loading)
            load_segment <= (state == LOAD_DELAY) && (delay_bit_cnt == 3'd4);
    end

    always @(posedge clk) begin
        if (reset)
            segment_count <= 4'd0;
        else if (load_segment)
            segment_count <= delay_reg + 1'b1;
        else if ((state == COUNT) && (cycle_counter == 10'd999) && (segment_count != 4'd0))
            segment_count <= segment_count - 1'b1;
    end

    // FSM next state logic
    always @(*) begin
        state_next = state;
        case(state)
            SEARCH: begin
                if (pattern_found)
                    state_next = LOAD_DELAY;
            end
            LOAD_DELAY: begin
                if (delay_bit_cnt == 3'd4)
                    state_next = COUNT;
            end
            COUNT: begin
                // When last segment finished (segment_count == 0 and cycle_counter == 999)
                if ((segment_count == 4'd0) && (cycle_counter == 10'd999))
                    state_next = DONE_WAIT_ACK;
            end
            DONE_WAIT_ACK: begin
                if (ack)
                    state_next = SEARCH;
            end
        endcase
    end

    // Outputs logic
    always @(posedge clk) begin
        if (reset) begin
            counting <= 1'b0;
            done <= 1'b0;
            count <= 4'd0;
        end else begin
            case(state)
                SEARCH: begin
                    counting <= 1'b0;
                    done <= 1'b0;
                    count <= 4'd0;  // don't care, choose zero for stable outputs
                end
                LOAD_DELAY: begin
                    counting <= 1'b0;
                    done <= 1'b0;
                    count <= 4'd0;  // don't care
                end
                COUNT: begin
                    counting <= 1'b1;
                    done <= 1'b0;
                    count <= segment_count;
                end
                DONE_WAIT_ACK: begin
                    counting <= 1'b0;
                    done <= 1'b1;
                    count <= 4'd0;  // don't care
                end
                default: begin
                    counting <= 1'b0;
                    done <= 1'b0;
                    count <= 4'd0;
                end
            endcase
        end
    end

endmodule