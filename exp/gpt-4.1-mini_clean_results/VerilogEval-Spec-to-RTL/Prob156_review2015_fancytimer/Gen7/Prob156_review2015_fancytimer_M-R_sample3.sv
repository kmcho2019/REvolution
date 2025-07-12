module TopModule (
    input  wire       clk,
    input  wire       reset,   // synchronous active-high reset
    input  wire       data,
    output reg [3:0]  count,
    output reg        counting,
    output reg        done,
    input  wire       ack
);

    // State one-hot encoding for simpler entry detection
    localparam [3:0]
        S_SEARCH    = 4'b0001,
        S_LOAD      = 4'b0010,
        S_COUNT     = 4'b0100,
        S_WAIT_ACK  = 4'b1000;

    reg [3:0] state, state_next;

    // Pattern detection shift register: shifts every cycle in SEARCH state
    reg [3:0] pattern_shift;

    // Delay register: shifts in MSB first in LOAD state by shifting right and inserting at MSB
    reg [3:0] delay_reg;
    reg [2:0] delay_bit_count; // counts loaded delay bits (0..4)

    // Counters for timer
    reg [9:0] cycle_counter; // counts 0..999 clock cycles
    reg [3:0] tick_counter;  // counts how many 1000-cycle intervals remain

    // Detect pattern matched combinationally
    wire pattern_matched = (pattern_shift == 4'b1101);

    // State register with synchronous reset
    always @(posedge clk) begin
        if (reset)
            state <= S_SEARCH;
        else
            state <= state_next;
    end

    // State next logic and shift register updates
    always @(*) begin
        // Default assignments
        state_next = state;

        case(state)
            S_SEARCH: begin
                if (pattern_matched)
                    state_next = S_LOAD;
            end

            S_LOAD: begin
                if (delay_bit_count == 3'd4)
                    state_next = S_COUNT;
            end

            S_COUNT: begin
                // When finished counting (tick_counter==0 and cycle_counter==999), go to wait ack
                if ((tick_counter == 0) && (cycle_counter == 10'd999))
                    state_next = S_WAIT_ACK;
            end

            S_WAIT_ACK: begin
                if (ack)
                    state_next = S_SEARCH;
            end

            default: state_next = S_SEARCH;
        endcase
    end

    // For detecting state entry pulses (one clock wide pulse on entering a state)
    reg [3:0] state_d;
    wire entry_search   = (state == S_SEARCH)   && (state_d != S_SEARCH);
    wire entry_load     = (state == S_LOAD)     && (state_d != S_LOAD);
    wire entry_count    = (state == S_COUNT)    && (state_d != S_COUNT);
    wire entry_wait_ack = (state == S_WAIT_ACK) && (state_d != S_WAIT_ACK);

    always @(posedge clk) begin
        if (reset)
            state_d <= 4'd0;
        else
            state_d <= state;
    end

    // Shift registers for pattern detection and delay loading
    always @(posedge clk) begin
        if (reset) begin
            pattern_shift   <= 4'b0000;
            delay_reg       <= 4'b0000;
            delay_bit_count <= 3'd0;
        end else begin
            case(state)
                S_SEARCH: begin
                    // Shift in new data bit for pattern detection
                    pattern_shift <= {pattern_shift[2:0], data};
                    delay_bit_count <= 3'd0;
                    delay_reg <= 4'b0000;
                end
                S_LOAD: begin
                    // Shift in delay bits MSB first by shifting right and inserting at MSB
                    // Example: delay_reg = {new_bit, delay_reg[3:1]};
                    delay_reg <= {data, delay_reg[3:1]};
                    delay_bit_count <= delay_bit_count + 1'b1;
                end
                default: begin
                    // Hold values steady
                    pattern_shift   <= pattern_shift;
                    delay_reg       <= delay_reg;
                    delay_bit_count <= delay_bit_count;
                end
            endcase
        end
    end

    // Timer counters and output logic
    always @(posedge clk) begin
        if (reset) begin
            cycle_counter <= 10'd0;
            tick_counter  <= 4'd0;
            count         <= 4'bxxxx; // don't care on reset
            counting      <= 1'b0;
            done          <= 1'b0;
        end else begin
            case(state)
                S_SEARCH: begin
                    // Timer inactive
                    cycle_counter <= 10'd0;
                    tick_counter  <= 4'd0;
                    count         <= 4'bxxxx;
                    counting      <= 1'b0;
                    done          <= 1'b0;
                end
                S_LOAD: begin
                    // Timer inactive during delay loading
                    cycle_counter <= 10'd0;
                    tick_counter  <= 4'd0;
                    count         <= 4'bxxxx;
                    counting      <= 1'b0;
                    done          <= 1'b0;
                end
                S_COUNT: begin
                    counting <= 1'b1;
                    done <= 1'b0;

                    // On state entry, initialize counters
                    if (entry_count) begin
                        tick_counter  <= delay_reg + 1'b1;  // delay + 1 intervals
                        cycle_counter <= 10'd0;
                        count         <= delay_reg + 1'b1;
                    end else begin
                        // Counting logic
                        if (cycle_counter == 10'd999) begin
                            cycle_counter <= 10'd0;
                            if (tick_counter != 0)
                                tick_counter <= tick_counter - 1'b1;
                            // Update count to show remaining ticks
                            count <= (tick_counter > 0) ? (tick_counter - 1'b1) : 4'd0;
                        end else begin
                            cycle_counter <= cycle_counter + 1'b1;
                            // Hold count steady during each 1000 cycle period
                            count <= tick_counter;
                        end
                    end
                end
                S_WAIT_ACK: begin
                    counting <= 1'b0;
                    done <= 1'b1;
                    count <= 4'bxxxx; // don't care when done
                    cycle_counter <= 10'd0;
                    tick_counter  <= 4'd0;
                end
                default: begin
                    // Safety defaults
                    counting <= 1'b0;
                    done <= 1'b0;
                    count <= 4'bxxxx;
                    cycle_counter <= 10'd0;
                    tick_counter <= 4'd0;
                end
            endcase
        end
    end

endmodule