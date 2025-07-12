module TopModule (
    input clk,
    input reset,
    input data,
    output reg [3:0] count,
    output reg counting,
    output reg done,
    input ack
);

    // States
    localparam S_SEARCH     = 2'd0;
    localparam S_SHIFT_DELAY= 2'd1;
    localparam S_COUNT      = 2'd2;
    localparam S_DONE       = 2'd3;

    reg [1:0] state, next_state;

    // Shift register for pattern detection
    reg [3:0] shift_in;

    // Delay register to hold delay[3:0]
    reg [3:0] delay;

    // Count how many bits of delay have been shifted in
    reg [2:0] delay_bits_count;

    // Cycle counter for counting 1000 clock cycles per decrement
    reg [9:0] cycle_counter; // 10 bits to count up to 1000 (0 to 999)

    // Remaining delay count for output and counting logic
    reg [3:0] remaining_delay;

    // Pattern to detect: 1101 binary = 4'b1101
    wire pattern_detected = (shift_in == 4'b1101);

    // Synchronous process
    always @(posedge clk) begin
        if (reset) begin
            state <= S_SEARCH;
            shift_in <= 4'd0;
            delay <= 4'd0;
            delay_bits_count <= 3'd0;
            cycle_counter <= 10'd0;
            remaining_delay <= 4'd0;
            counting <= 1'b0;
            done <= 1'b0;
            count <= 4'bxxxx; // don't care, assign default
        end else begin
            state <= next_state;

            case(state)
                S_SEARCH: begin
                    // Shift in data to shift_in to detect pattern 1101
                    shift_in <= {shift_in[2:0], data};
                    counting <= 1'b0;
                    done <= 1'b0;
                    count <= 4'bxxxx; // don't care
                    delay_bits_count <= 3'd0;
                    cycle_counter <= 10'd0;
                    remaining_delay <= 4'd0;
                end

                S_SHIFT_DELAY: begin
                    // Shift in next 4 bits MSB first into delay
                    delay <= {delay[2:0], data};
                    delay_bits_count <= delay_bits_count + 1'b1;
                    counting <= 1'b0;
                    done <= 1'b0;
                    count <= 4'bxxxx; // don't care
                    cycle_counter <= 10'd0;
                    remaining_delay <= 4'd0;
                end

                S_COUNT: begin
                    counting <= 1'b1;
                    done <= 1'b0;
                    // count output is current remaining_delay
                    count <= remaining_delay;

                    if (cycle_counter == 10'd999) begin
                        cycle_counter <= 10'd0;
                        if (remaining_delay != 4'd0) begin
                            remaining_delay <= remaining_delay - 1'b1;
                        end else begin
                            // counting done after last 1000 cycles at delay=0
                            // Stay in COUNT for this cycle then go to DONE
                        end
                    end else begin
                        cycle_counter <= cycle_counter + 1'b1;
                    end
                end

                S_DONE: begin
                    counting <= 1'b0;
                    done <= 1'b1;
                    count <= 4'bxxxx; // don't care
                    // Wait for ack, no change in internal variables here
                end

                default: begin
                    // Default safe values
                    state <= S_SEARCH;
                    shift_in <= 4'd0;
                    delay <= 4'd0;
                    delay_bits_count <= 3'd0;
                    cycle_counter <= 10'd0;
                    remaining_delay <= 4'd0;
                    counting <= 1'b0;
                    done <= 1'b0;
                    count <= 4'bxxxx;
                end
            endcase
        end
    end

    // Next state logic
    always @(*) begin
        next_state = state;
        case(state)
            S_SEARCH: begin
                if (pattern_detected)
                    next_state = S_SHIFT_DELAY;
                else
                    next_state = S_SEARCH;
            end

            S_SHIFT_DELAY: begin
                if (delay_bits_count == 3'd4)
                    next_state = S_COUNT;
                else
                    next_state = S_SHIFT_DELAY;
            end

            S_COUNT: begin
                // When remaining_delay==0 and cycle_counter==999 (end of last 1000 cycle block)
                // move to DONE
                if ((remaining_delay == 4'd0) && (cycle_counter == 10'd999))
                    next_state = S_DONE;
                else
                    next_state = S_COUNT;
            end

            S_DONE: begin
                if (ack)
                    next_state = S_SEARCH;
                else
                    next_state = S_DONE;
            end

            default: next_state = S_SEARCH;
        endcase
    end

    // Load remaining_delay at start of COUNT state, once after shifting delay bits
    // Use a registered signal to load it exactly once
    reg load_remaining_delay;

    always @(posedge clk) begin
        if (reset) begin
            load_remaining_delay <= 1'b0;
        end else begin
            if (state == S_SHIFT_DELAY && delay_bits_count == 3'd4) begin
                load_remaining_delay <= 1'b1;
            end else begin
                load_remaining_delay <= 1'b0;
            end

            if (load_remaining_delay) begin
                remaining_delay <= delay;
                cycle_counter <= 10'd0;
            end
        end
    end

endmodule