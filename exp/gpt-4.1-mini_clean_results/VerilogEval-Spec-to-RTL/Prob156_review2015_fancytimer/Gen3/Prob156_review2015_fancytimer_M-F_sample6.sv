module TopModule(
    input clk,
    input reset,
    input data,
    output reg [3:0] count,
    output counting,
    output done,
    input ack
);

    // State encoding
    typedef enum logic [1:0] {
        SEARCH     = 2'd0,
        READ_DELAY = 2'd1,
        COUNT      = 2'd2,
        DONE       = 2'd3
    } state_t;

    state_t state, next_state;

    reg [3:0] shift_reg;    // Shift register for pattern detection and delay reading
    reg [2:0] bits_read;    // Count bits read in READ_DELAY: 0 to 4
    reg [3:0] delay_reg;    // Stores delay bits read

    reg [3:0] remaining;    // Remaining delay ticks (delay+1) down to 0
    reg [9:0] cycle_count;  // Counts 0..999 cycles per tick

    // Outputs combinational
    assign counting = (state == COUNT);
    assign done = (state == DONE);

    // Next state logic combinational
    always @(*) begin
        next_state = state;
        case(state)
            SEARCH: begin
                // Pattern to detect: 1101
                // shift_reg holds last 4 bits shifted in MSB first: {shift_reg[3],..., shift_reg[0]}
                if (shift_reg == 4'b1101)
                    next_state = READ_DELAY;
            end
            READ_DELAY: begin
                if (bits_read == 3'd4)
                    next_state = COUNT;
            end
            COUNT: begin
                // Finish counting when remaining=0 and last cycle_count=999 done
                if ((remaining == 4'd0) && (cycle_count == 10'd999))
                    next_state = DONE;
            end
            DONE: begin
                if (ack)
                    next_state = SEARCH;
            end
        endcase
    end

    // Sequential logic block
    always @(posedge clk) begin
        if (reset) begin
            // Reset all registers and state
            state <= SEARCH;
            shift_reg <= 4'd0;
            bits_read <= 3'd0;
            delay_reg <= 4'd0;
            remaining <= 4'd0;
            cycle_count <= 10'd0;
            count <= 4'd0;
        end else begin
            state <= next_state;

            case(state)
                SEARCH: begin
                    // Shift in data MSB first: shift left, input bit at LSB
                    // No clearing shift_reg here, keep sliding window of last 4 bits
                    shift_reg <= {shift_reg[2:0], data};
                    bits_read <= 3'd0;
                    delay_reg <= 4'd0;
                    remaining <= 4'd0;
                    cycle_count <= 10'd0;
                    count <= 4'd0;
                end

                READ_DELAY: begin
                    // Shift in delay bits MSB first: shift left, input bit at LSB
                    delay_reg <= {delay_reg[2:0], data};
                    bits_read <= bits_read + 1'b1;

                    // Keep shift_reg unchanged in this state (not needed)
                    shift_reg <= shift_reg;
                    remaining <= 4'd0;
                    cycle_count <= 10'd0;
                    count <= 4'd0;
                end

                COUNT: begin
                    // Output current remaining delay
                    count <= remaining;

                    if (cycle_count == 10'd999) begin
                        cycle_count <= 10'd0;

                        if (remaining != 4'd0) begin
                            remaining <= remaining - 1'b1;
                        end
                        // else remaining == 0: do not decrement further
                    end else begin
                        cycle_count <= cycle_count + 1'b1;
                    end

                    // Keep delay_reg, bits_read, shift_reg unchanged
                    delay_reg <= delay_reg;
                    bits_read <= bits_read;
                    shift_reg <= shift_reg;
                end

                DONE: begin
                    // Done state outputs
                    count <= 4'd0;
                    cycle_count <= 10'd0;
                    remaining <= 4'd0;
                    bits_read <= 3'd0;
                    shift_reg <= shift_reg;
                    delay_reg <= delay_reg;
                end

                default: begin
                    // Should not occur, safe defaults
                    shift_reg <= 4'd0;
                    bits_read <= 3'd0;
                    delay_reg <= 4'd0;
                    remaining <= 4'd0;
                    cycle_count <= 10'd0;
                    count <= 4'd0;
                end
            endcase

            // On transition from READ_DELAY to COUNT, load remaining with delay + 1
            if ((state == READ_DELAY) && (next_state == COUNT)) begin
                // delay_reg holds valid 4-bit delay read MSB first
                remaining <= delay_reg + 4'd1;
                cycle_count <= 10'd0;
                count <= delay_reg + 4'd1;  // update count immediately to remaining
            end
        end
    end

endmodule