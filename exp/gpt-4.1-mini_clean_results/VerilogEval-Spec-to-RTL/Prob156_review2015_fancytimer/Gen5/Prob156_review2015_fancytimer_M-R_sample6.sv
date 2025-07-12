module TopModule (
    input        clk,
    input        reset,  // synchronous active-high reset
    input        data,
    output reg [3:0] count,
    output reg       counting,
    output reg       done,
    input        ack
);

    // FSM states
    typedef enum reg [1:0] {
        SEARCH  = 2'b00,  // Searching for start pattern 1101
        LOAD    = 2'b01,  // Loading 4 delay bits MSB first
        COUNT   = 2'b10,  // Counting timer cycles
        WAIT_ACK= 2'b11   // Waiting for ack after timer done
    } state_t;

    reg [1:0] state, next_state;

    // Rolling shift register for pattern detection (keep last 4 bits)
    reg [3:0] pattern_shift;

    // Delay register and bit counter (loading MSB first)
    reg [3:0] delay_reg;
    reg [2:0] delay_bits_loaded; // from 0 to 4

    // Timer counters
    reg [11:0] cycle_counter; // counts 0..999
    reg [4:0]  tick_counter;  // counts delay+1 down to 0 (max 17 needed for 4 bits +1)

    // Next state logic inside sequential block for clarity
    always @(posedge clk) begin
        if (reset) begin
            state <= SEARCH;
            pattern_shift <= 4'd0;
            delay_reg <= 4'd0;
            delay_bits_loaded <= 3'd0;
            cycle_counter <= 12'd0;
            tick_counter <= 5'd0;
            count <= 4'd0;
            counting <= 1'b0;
            done <= 1'b0;
        end else begin
            case (state)
                SEARCH: begin
                    // Shift in data to pattern_shift to detect start pattern 1101
                    pattern_shift <= {pattern_shift[2:0], data};

                    // Default outputs while searching
                    counting <= 1'b0;
                    done <= 1'b0;
                    count <= 4'd0;

                    if (pattern_shift == 4'b1101) begin
                        // Detected start pattern, start loading delay bits next cycle
                        state <= LOAD;
                        delay_bits_loaded <= 3'd0;
                        delay_reg <= 4'd0;
                    end
                end

                LOAD: begin
                    // Shift in delay bits MSB first: shift left, add LSB=data
                    delay_reg <= {delay_reg[2:0], data};
                    delay_bits_loaded <= delay_bits_loaded + 3'd1;

                    counting <= 1'b0;
                    done <= 1'b0;
                    count <= 4'd0;

                    if (delay_bits_loaded == 3'd3) begin
                        // Last delay bit shifted in on this cycle, prepare to start counting next
                        tick_counter <= delay_reg + 5'd1; // delay + 1 timer ticks
                        cycle_counter <= 12'd0;
                        state <= COUNT;
                    end
                end

                COUNT: begin
                    counting <= 1'b1;
                    done <= 1'b0;

                    // count = tick_counter - 1 if tick_counter > 0 else 0
                    count <= (tick_counter == 0) ? 4'd0 : (tick_counter - 1);

                    // Increment cycle counter up to 999
                    if (cycle_counter == 12'd999) begin
                        cycle_counter <= 12'd0;
                        if (tick_counter != 0)
                            tick_counter <= tick_counter - 5'd1;
                        // After decrementing tick_counter, if zero, counting done next cycle
                        if (tick_counter == 1) begin
                            // finished last 1000 cycle chunk this cycle
                            state <= WAIT_ACK;
                            counting <= 1'b0;
                            done <= 1'b1;
                            count <= 4'd0;
                        end
                    end else begin
                        cycle_counter <= cycle_counter + 12'd1;
                    end
                end

                WAIT_ACK: begin
                    counting <= 1'b0;
                    done <= 1'b1;
                    count <= 4'd0;

                    // pattern_shift should keep shifting to keep track, but specs say ignore data during counting/done
                    // So hold pattern_shift as-is (or optionally shift, no effect)

                    if (ack) begin
                        state <= SEARCH;
                        pattern_shift <= 4'd0;
                        delay_reg <= 4'd0;
                        delay_bits_loaded <= 3'd0;
                        cycle_counter <= 12'd0;
                        tick_counter <= 5'd0;
                        done <= 1'b0;
                    end
                end

                default: begin
                    // Safety fallback to SEARCH state
                    state <= SEARCH;
                    pattern_shift <= 4'd0;
                    delay_reg <= 4'd0;
                    delay_bits_loaded <= 3'd0;
                    cycle_counter <= 12'd0;
                    tick_counter <= 5'd0;
                    count <= 4'd0;
                    counting <= 1'b0;
                    done <= 1'b0;
                end
            endcase
        end
    end

endmodule