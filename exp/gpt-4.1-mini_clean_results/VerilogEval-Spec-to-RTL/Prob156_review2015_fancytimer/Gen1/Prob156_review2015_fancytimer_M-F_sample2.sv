module TopModule(
    input clk,
    input reset,
    input data,
    output reg [3:0] count,
    output reg counting,
    output reg done,
    input ack
);

    // FSM states
    typedef enum logic [1:0] {
        SEARCH     = 2'd0,
        READ_DELAY = 2'd1,
        COUNT      = 2'd2,
        DONE       = 2'd3
    } state_t;

    state_t state, next_state;

    // Shift register to detect 4-bit pattern 1101 in SEARCH
    reg [3:0] pattern_shift;

    // Delay bits and counter for how many delay bits read
    reg [3:0] delay;            // holds delay value after READ_DELAY complete
    reg [2:0] delay_bits_read;  // counts 0 to 3

    // Counters for COUNT state
    reg [9:0] cycle_count;      // counts from 0 to 999 (1000 cycles)
    reg [3:0] remaining;        // counts down from delay to 0, output as count

    // Synchronous state and registers update
    always @(posedge clk) begin
        if (reset) begin
            state <= SEARCH;
            pattern_shift <= 4'b0;
            delay <= 4'b0;
            delay_bits_read <= 3'd0;
            cycle_count <= 10'd0;
            remaining <= 4'd0;
            counting <= 1'b0;
            done <= 1'b0;
            count <= 4'd0;
        end else begin
            state <= next_state;

            case (state)
                SEARCH: begin
                    // Shift in data bit to detect pattern 1101
                    pattern_shift <= {pattern_shift[2:0], data};
                    delay_bits_read <= 3'd0;
                    // Outputs
                    counting <= 1'b0;
                    done <= 1'b0;
                    count <= 4'd0;
                    cycle_count <= 10'd0;
                    remaining <= 4'd0;
                    // delay left unchanged here (valid after READ_DELAY)
                end

                READ_DELAY: begin
                    // Shift delay left and insert data bit at LSB (MSB first)
                    delay <= {delay[2:0], data};
                    delay_bits_read <= delay_bits_read + 1'b1;

                    // Outputs stay inactive
                    counting <= 1'b0;
                    done <= 1'b0;
                    count <= 4'd0;

                    cycle_count <= 10'd0;
                    remaining <= 4'd0;
                end

                COUNT: begin
                    counting <= 1'b1;
                    done <= 1'b0;
                    count <= remaining;

                    if (cycle_count == 10'd999) begin
                        cycle_count <= 10'd0;
                        if (remaining != 4'd0) begin
                            remaining <= remaining - 1'b1;
                        end else begin
                            // remaining is zero and last 1000 cycles done, keep it zero
                            remaining <= 4'd0;
                        end
                    end else begin
                        cycle_count <= cycle_count + 1'b1;
                        remaining <= remaining; // hold
                    end
                end

                DONE: begin
                    counting <= 1'b0;
                    done <= 1'b1;
                    count <= 4'd0;
                    // Hold counters zeroed to safe default
                    cycle_count <= 10'd0;
                    remaining <= 4'd0;
                    // Keep pattern_shift and delay_bits_read stable until SEARCH resets them
                end

                default: begin
                    // Default safe values
                    counting <= 1'b0;
                    done <= 1'b0;
                    count <= 4'd0;
                end
            endcase
        end
    end

    // Next-state combinational logic
    always @(*) begin
        next_state = state;
        case (state)
            SEARCH: begin
                // Wait for pattern 1101 to appear in pattern_shift (4 bits)
                if (pattern_shift == 4'b1101) begin
                    next_state = READ_DELAY;
                end
            end

            READ_DELAY: begin
                // After reading 4 bits (delay_bits_read == 3 means last bit read this cycle)
                if (delay_bits_read == 3'd3) begin
                    next_state = COUNT;
                end
            end

            COUNT: begin
                // When remaining == 0 and cycle_count == 999, counting complete
                if ((remaining == 4'd0) && (cycle_count == 10'd999)) begin
                    next_state = DONE;
                end
            end

            DONE: begin
                // Wait for user ack signal to restart searching
                if (ack) begin
                    next_state = SEARCH;
                end
            end

            default: next_state = SEARCH;
        endcase
    end

endmodule