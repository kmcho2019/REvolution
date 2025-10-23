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
    localparam COUNT       = 2'd2;
    localparam DONE_STATE  = 2'd3;

    reg [1:0] state, next_state;

    // Shift register to detect pattern 1101
    reg [3:0] pattern_shift;

    // Delay bits captured
    reg [3:0] delay;

    // Count of bits shifted in SHIFT_DELAY
    reg [2:0] delay_bits_count;

    // 1000-cycle counter (0 to 999)
    reg [9:0] cycle_counter;

    // Remaining count for delay down count
    // Using integer for clarity; could use reg[3:0] but max 15 fits 4 bits
    reg [3:0] delay_counter;

    // Next count value (remaining time output)
    // count outputs delay_counter value during counting
    // otherwise don't care, so we keep count valid only in COUNT state

    // FSM sequential logic
    always @(posedge clk) begin
        if (reset) begin
            state <= SEARCH;
            pattern_shift <= 4'b0000;
            delay <= 4'b0000;
            delay_bits_count <= 3'd0;
            cycle_counter <= 10'd0;
            delay_counter <= 4'd0;
            counting <= 1'b0;
            done <= 1'b0;
            count <= 4'bxxxx;
        end else begin
            state <= next_state;

            case(state)
                SEARCH: begin
                    counting <= 1'b0;
                    done <= 1'b0;
                    count <= 4'bxxxx;
                    // shift in data to pattern_shift
                    pattern_shift <= {pattern_shift[2:0], data};
                end

                SHIFT_DELAY: begin
                    // shift in delay bits MSB first
                    delay <= {delay[2:0], data};
                    delay_bits_count <= delay_bits_count + 1'b1;
                end

                COUNT: begin
                    counting <= 1'b1;
                    done <= 1'b0;
                    count <= delay_counter;

                    // Count 1000 cycles per delay_counter value
                    if (cycle_counter == 10'd999) begin
                        cycle_counter <= 10'd0;
                        if (delay_counter == 0) begin
                            // Counting done
                            counting <= 1'b0;
                            done <= 1'b1;
                            count <= 4'bxxxx;
                        end else begin
                            delay_counter <= delay_counter - 1'b1;
                        end
                    end else begin
                        cycle_counter <= cycle_counter + 1'b1;
                    end
                end

                DONE_STATE: begin
                    counting <= 1'b0;
                    done <= 1'b1;
                    count <= 4'bxxxx;
                    // Wait for ack to return to SEARCH
                end

            endcase
        end
    end

    // FSM combinational next state logic
    always @(*) begin
        next_state = state;
        case(state)
            SEARCH: begin
                // Check if pattern_shift == 1101
                // pattern_shift always has last 4 data bits shifted in
                // When equal to 4'b1101, go to SHIFT_DELAY
                if (pattern_shift == 4'b1101)
                    next_state = SHIFT_DELAY;
            end

            SHIFT_DELAY: begin
                if (delay_bits_count == 3'd3) // after shifting 4 bits (0 to 3)
                    next_state = COUNT;
            end

            COUNT: begin
                // Count state finishes when delay_counter==0 and cycle_counter==999 (end of last 1000 cycle)
                if ((delay_counter == 0) && (cycle_counter == 10'd999))
                    next_state = DONE_STATE;
            end

            DONE_STATE: begin
                // Wait for ack to go back to SEARCH and reset variables
                if (ack)
                    next_state = SEARCH;
            end
        endcase
    end

    // State entry/reset logic for variables updated in FSM

    // delay_bits_count, delay_counter, cycle_counter reset on entering states
    always @(posedge clk) begin
        if (reset) begin
            delay_bits_count <= 3'd0;
            delay_counter <= 4'd0;
            cycle_counter <= 10'd0;
            pattern_shift <= 4'b0000;
        end else begin
            if (state != next_state) begin
                // State transition detected
                case(next_state)
                    SEARCH: begin
                        // Reset pattern shift and counters for new search
                        pattern_shift <= 4'b0000;
                        delay_bits_count <= 3'd0;
                        cycle_counter <= 10'd0;
                        delay_counter <= 4'd0;
                    end
                    SHIFT_DELAY: begin
                        // Start shifting delay bits
                        delay_bits_count <= 3'd0;
                        delay <= 4'b0000;
                    end
                    COUNT: begin
                        // Initialize counters:
                        // delay_counter = delay input
                        // cycle_counter reset
                        delay_counter <= delay;
                        cycle_counter <= 10'd0;
                    end
                    DONE_STATE: begin
                        // Nothing special, waiting for ack
                    end
                endcase
            end
        end
    end

endmodule