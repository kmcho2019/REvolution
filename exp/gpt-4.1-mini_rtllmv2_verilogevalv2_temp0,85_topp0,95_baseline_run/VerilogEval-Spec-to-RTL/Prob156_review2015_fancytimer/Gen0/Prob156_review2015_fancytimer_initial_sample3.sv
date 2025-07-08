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
    localparam SEARCH       = 2'd0;
    localparam READ_DELAY   = 2'd1;
    localparam COUNTING     = 2'd2;
    localparam DONE         = 2'd3;

    reg [1:0] state, next_state;

    // Shift register for pattern detection
    reg [3:0] pattern_shift;

    // Delay shift register
    reg [3:0] delay_reg;

    // Delay count remaining (0 to delay)
    reg [3:0] delay_count;

    // Sub-counter to count 1000 cycles per delay decrement
    reg [9:0] cycle_count; // enough for 0 to 999

    // Main timer count in cycles: (delay+1)*1000
    // We'll just use cycle_count and delay_count to track counting

    // Sequential logic
    always @(posedge clk) begin
        if (reset) begin
            state <= SEARCH;
            pattern_shift <= 4'b0000;
            delay_reg <= 4'b0000;
            delay_count <= 4'b0000;
            cycle_count <= 10'd0;
            counting <= 1'b0;
            done <= 1'b0;
            count <= 4'bxxxx; // don't care, but assign x
        end else begin
            state <= next_state;

            case(state)
                SEARCH: begin
                    counting <= 1'b0;
                    done <= 1'b0;
                    // shift in pattern bits
                    pattern_shift <= {pattern_shift[2:0], data};
                    count <= 4'bxxxx; // don't care

                    // delay_reg, delay_count, cycle_count unchanged
                end

                READ_DELAY: begin
                    counting <= 1'b0;
                    done <= 1'b0;
                    // Shift in delay MSB first
                    delay_reg <= {delay_reg[2:0], data};
                    // pattern_shift unchanged
                    count <= 4'bxxxx;
                end

                COUNTING: begin
                    done <= 1'b0;
                    counting <= 1'b1;

                    // count output is current delay_count
                    count <= delay_count;

                    if (cycle_count == 10'd0) begin
                        // Just rolled over, decrement delay_count if not zero
                        if (delay_count != 4'd0) begin
                            delay_count <= delay_count - 1'b1;
                            cycle_count <= 10'd999; // reload cycle count
                        end else begin
                            // delay_count == 0 and cycle_count == 0 means counting done
                            cycle_count <= 10'd0;
                        end
                    end else begin
                        cycle_count <= cycle_count - 1'b1;
                    end
                end

                DONE: begin
                    counting <= 1'b0;
                    done <= 1'b1;
                    count <= 4'bxxxx;
                    // wait for ack to return to SEARCH handled in FSM next_state
                end
            endcase
        end
    end

    // Next state logic
    always @(*) begin
        next_state = state;

        case(state)
            SEARCH: begin
                // pattern_shift has last 4 bits, check if equals 1101
                if (pattern_shift == 4'b1101) begin
                    next_state = READ_DELAY;
                end else begin
                    next_state = SEARCH;
                end
            end

            READ_DELAY: begin
                // We shift in 4 bits total for delay
                // Use a counter for bits read? Since delay_reg holds bits shifted in,
                // the count of bits shifted in can be tracked by a counter or by looking
                // at how many bits shifted. We'll add a counter for bits_read_delay

                // We'll handle this using an internal reg bits_read_delay

                // This combinational block doesn't handle bits_read_delay so set next state to READ_DELAY
                // and we'll add that logic in sequential to move to COUNTING.

                // To solve this cleanly, add bits_read_delay counter.

                // So for now, next_state = (bits_read_delay == 4) ? COUNTING : READ_DELAY
                next_state = READ_DELAY; // placeholder
            end

            COUNTING: begin
                // Count down until done

                // When delay_count == 0 and cycle_count == 0, counting done
                if ((delay_count == 4'd0) && (cycle_count == 10'd0)) begin
                    next_state = DONE;
                end else begin
                    next_state = COUNTING;
                end
            end

            DONE: begin
                // Wait for ack to go back to SEARCH
                if (ack) begin
                    next_state = SEARCH;
                end else begin
                    next_state = DONE;
                end
            end

            default: next_state = SEARCH;
        endcase
    end

    // bits_read_delay counter for READ_DELAY state
    reg [2:0] bits_read_delay;

    always @(posedge clk) begin
        if (reset) begin
            bits_read_delay <= 3'd0;
        end else begin
            if (state == READ_DELAY) begin
                bits_read_delay <= bits_read_delay + 1'b1;
            end else begin
                bits_read_delay <= 3'd0;
            end
        end
    end

    // Modify next_state logic to use bits_read_delay:
    always @(*) begin
        if (state == READ_DELAY) begin
            if (bits_read_delay == 3'd4) begin
                // Load delay_count and cycle_count on next clock
                next_state = COUNTING;
            end else begin
                next_state = READ_DELAY;
            end
        end
    end

    // Load delay_count and cycle_count at transition from READ_DELAY to COUNTING
    // This requires detecting that we are in READ_DELAY and bits_read_delay == 4

    // Create a load signal for counters
    wire load_counters = (state == READ_DELAY) && (bits_read_delay == 3'd4);

    always @(posedge clk) begin
        if (reset) begin
            delay_count <= 4'd0;
            cycle_count <= 10'd0;
        end else if (load_counters) begin
            delay_count <= delay_reg;
            cycle_count <= 10'd999; // start counting from 999 down to 0 (total 1000 cycles)
        end else if (state == COUNTING) begin
            // cycle_count and delay_count update already handled above
            // no additional logic needed here
        end
    end

endmodule