module TopModule (
    input  clk,
    input  reset,
    input  data,
    output reg [3:0] count,
    output reg counting,
    output reg done,
    input  ack
);

    // State encoding
    localparam STATE_SEARCH     = 2'd0;
    localparam STATE_SHIFT_DELAY= 2'd1;
    localparam STATE_COUNT      = 2'd2;
    localparam STATE_DONE       = 2'd3;

    reg [1:0] state, next_state;

    // Shift register to detect pattern 1101
    reg [3:0] pattern_shift;

    // Delay register (4 bits)
    reg [3:0] delay_reg;

    // Bit counter for delay input bits shifted in
    reg [2:0] delay_bit_count; // max 4 bits needed, 3 bits width is enough

    // 1000-cycle counter
    reg [9:0] cycle_count; // needs to count to 1000 (0 to 999)

    // Remaining delay count (used as output count)
    reg [3:0] remaining;

    // Sequential logic for state transitions and registers
    always @(posedge clk) begin
        if (reset) begin
            state <= STATE_SEARCH;
            pattern_shift <= 4'b0;
            delay_reg <= 4'b0;
            delay_bit_count <= 3'd0;
            cycle_count <= 10'd0;
            remaining <= 4'd0;
            count <= 4'bxxxx;
            counting <= 1'b0;
            done <= 1'b0;
        end else begin
            state <= next_state;
            case(state)
                STATE_SEARCH: begin
                    // Shift in data bit into pattern_shift (MSB oldest, LSB newest)
                    pattern_shift <= {pattern_shift[2:0], data};
                    // outputs idle
                    counting <= 1'b0;
                    done <= 1'b0;
                    count <= 4'bxxxx;
                end
                STATE_SHIFT_DELAY: begin
                    // Shift in delay bits MSB first
                    // We already detected pattern 1101 before entering this state
                    delay_reg <= {delay_reg[2:0], data};
                    delay_bit_count <= delay_bit_count + 1'b1;
                    counting <= 1'b0;
                    done <= 1'b0;
                    count <= 4'bxxxx;
                end
                STATE_COUNT: begin
                    done <= 1'b0;
                    counting <= 1'b1;
                    count <= remaining;
                    if (cycle_count == 10'd999) begin
                        cycle_count <= 10'd0;
                        if (remaining != 0)
                            remaining <= remaining - 1'b1;
                    end else begin
                        cycle_count <= cycle_count + 1'b1;
                    end
                end
                STATE_DONE: begin
                    counting <= 1'b0;
                    done <= 1'b1;
                    count <= 4'bxxxx;
                end
            endcase
        end
    end

    // Next state logic
    always @(*) begin
        next_state = state;
        case(state)
            STATE_SEARCH: begin
                // Detect pattern 1101 on pattern_shift
                // pattern_shift shifts in new bit at LSB every cycle; so pattern_shift is last 4 bits in order shifted in.
                // The pattern 1101 means bits in order: bit3=1, bit2=1, bit1=0, bit0=1
                if (pattern_shift == 4'b1101)
                    next_state = STATE_SHIFT_DELAY;
            end
            STATE_SHIFT_DELAY: begin
                if (delay_bit_count == 3'd4) begin
                    next_state = STATE_COUNT;
                end
            end
            STATE_COUNT: begin
                // Count for (delay+1)*1000 cycles = (remaining+1)*1000 cycles
                // We decrement remaining every 1000 cycles, starting at delay
                // When remaining hits 0 and cycle_count hits 999, counting done
                if ((remaining == 0) && (cycle_count == 10'd999))
                    next_state = STATE_DONE;
            end
            STATE_DONE: begin
                // Wait for ack=1 to go back to SEARCH
                if (ack)
                    next_state = STATE_SEARCH;
            end
            default: next_state = STATE_SEARCH;
        endcase
    end

    // Controls on entering states
    always @(posedge clk) begin
        if (reset) begin
            delay_bit_count <= 3'd0;
            delay_reg <= 4'b0;
            cycle_count <= 10'd0;
            remaining <= 4'd0;
            pattern_shift <= 4'b0;
        end else begin
            case(next_state)
                STATE_SEARCH: begin
                    // Clear delay inputs and counters
                    delay_bit_count <= 3'd0;
                    delay_reg <= 4'b0;
                    cycle_count <= 10'd0;
                    remaining <= 4'd0;
                    // pattern_shift updated in main always block
                end
                STATE_SHIFT_DELAY: begin
                    // delay_bit_count incremented in main always block
                    // delay_reg shifted in main always block
                end
                STATE_COUNT: begin
                    if (state != STATE_COUNT) begin
                        // On first cycle of counting state, initialize counters
                        cycle_count <= 10'd0;
                        remaining <= delay_reg;
                    end
                end
                STATE_DONE: begin
                    // no special init
                end
            endcase
        end
    end

endmodule