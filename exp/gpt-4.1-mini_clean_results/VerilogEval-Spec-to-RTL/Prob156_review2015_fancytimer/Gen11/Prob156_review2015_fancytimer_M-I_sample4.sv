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
        SEARCH        = 2'b00,
        LOAD_DELAY    = 2'b01,
        COUNT         = 2'b10,
        DONE_WAIT_ACK = 2'b11
    } state_t;

    reg [1:0] state, state_next;

    // Shift register for pattern detection
    reg [3:0] pattern_shift;

    // Delay loading
    reg [3:0] delay_reg;
    reg [2:0] delay_bit_cnt; // counts 0..3 (4 bits total)

    // Cycle counter counts clock cycles within each 1000 cycle segment
    reg [9:0] cycle_counter;  // counts 0..999

    // Segment counter: counts number of 1000-cycle segments left (delay+1 segments)
    reg [3:0] segment_count;

    // Detect start pattern 1101 (MSB first in shift reg)
    wire pattern_found = (pattern_shift == 4'b1101);

    // Sequential FSM state update
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

    // Delay bits loading, MSB first
    // Shift delay_reg left by one bit, insert data at LSB
    // Count delay bits 0..3
    always @(posedge clk) begin
        if (reset) begin
            delay_reg <= 4'b0000;
            delay_bit_cnt <= 3'd0;
        end else if (state == LOAD_DELAY) begin
            delay_reg <= {delay_reg[2:0], data};
            delay_bit_cnt <= delay_bit_cnt + 1'b1;
        end else begin
            delay_reg <= 4'b0000;
            delay_bit_cnt <= 3'd0;
        end
    end

    // Cycle counter counts 0 to 999 in COUNT state
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

    // Segment counter update: loaded after delay bits received,
    // decremented each 1000 cycle segment in COUNT state.
    always @(posedge clk) begin
        if (reset) begin
            segment_count <= 4'd0;
        end else begin
            if (state == LOAD_DELAY && delay_bit_cnt == 3'd4) begin
                // Delay bits fully loaded (after 4 bits, delay_bit_cnt has incremented to 4)
                // Load segment count = delay_reg + 1
                segment_count <= delay_reg + 1'b1;
            end else if (state == COUNT && cycle_counter == 10'd999 && segment_count != 0) begin
                segment_count <= segment_count - 1'b1;
            end
        end
    end

    // FSM next state logic
    always @(*) begin
        state_next = state;
        case (state)
            SEARCH: begin
                if (pattern_found)
                    state_next = LOAD_DELAY;
            end
            LOAD_DELAY: begin
                // delay_bit_cnt counts 0..4 during loading, when 4 bits loaded move to COUNT
                if (delay_bit_cnt == 3'd4)
                    state_next = COUNT;
            end
            COUNT: begin
                // When segment_count reaches zero after last 1000-cycle segment, done
                if ((segment_count == 4'd0) && (cycle_counter == 10'd999))
                    state_next = DONE_WAIT_ACK;
            end
            DONE_WAIT_ACK: begin
                if (ack)
                    state_next = SEARCH;
            end
        endcase
    end

    // Output logic
    always @(posedge clk) begin
        if (reset) begin
            counting <= 1'b0;
            done <= 1'b0;
            count <= 4'b0000;
        end else begin
            case (state)
                SEARCH: begin
                    counting <= 1'b0;
                    done <= 1'b0;
                    count <= 4'b0000; // don't care replaced with zero for simulation cleanliness
                end
                LOAD_DELAY: begin
                    counting <= 1'b0;
                    done <= 1'b0;
                    count <= 4'b0000; // don't care replaced with zero
                end
                COUNT: begin
                    counting <= 1'b1;
                    done <= 1'b0;
                    count <= segment_count; // remaining segments
                end
                DONE_WAIT_ACK: begin
                    counting <= 1'b0;
                    done <= 1'b1;
                    count <= 4'b0000; // don't care replaced with zero
                end
                default: begin
                    counting <= 1'b0;
                    done <= 1'b0;
                    count <= 4'b0000;
                end
            endcase
        end
    end

endmodule