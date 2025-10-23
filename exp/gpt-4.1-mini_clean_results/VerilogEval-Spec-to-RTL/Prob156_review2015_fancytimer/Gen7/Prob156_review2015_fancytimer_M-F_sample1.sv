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
        SEARCH   = 2'b00,  // Searching for start pattern 1101
        LOAD     = 2'b01,  // Loading 4 delay bits MSB first
        COUNT    = 2'b10,  // Counting timer cycles
        WAIT_ACK = 2'b11   // Waiting for ack after timer done
    } state_t;

    reg [1:0] state;

    // Shift register to detect pattern 1101 (4 bits)
    reg [3:0] pattern_shift;

    // Delay bits register and loaded bit count
    reg [3:0] delay_reg;
    reg [2:0] delay_bits_loaded;  // 0 to 4 bits loaded

    // Timer counters
    reg [11:0] cycle_counter;  // counts 0..999 (1000 cycles)
    reg [4:0]  tick_counter;   // counts (delay+1) down to 0

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

                    // Outputs in SEARCH state
                    counting <= 1'b0;
                    done <= 1'b0;
                    count <= 4'd0;

                    if (pattern_shift == 4'b1101) begin
                        // Detected start pattern, move to LOAD state next cycle
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
                        // After loading 4 bits (bits 0..3)
                        // Initialize tick_counter = delay + 1
                        // cycle_counter start at 0
                        tick_counter <= delay_reg + 5'd1;
                        cycle_counter <= 12'd0;
                        state <= COUNT;
                    end
                end

                COUNT: begin
                    counting <= 1'b1;
                    done <= 1'b0;

                    // Output count is current remaining tick - 1 (delay down to 0)
                    // tick_counter counts remaining 1000-cycle chunks
                    // When tick_counter > 0, count = tick_counter -1 (stable for 1000 cycles)
                    // When tick_counter == 0, counting is done
                    if (tick_counter > 0)
                        count <= tick_counter - 1;
                    else
                        count <= 4'd0;

                    if (cycle_counter == 12'd999) begin
                        // Completed 1000 cycles for current tick
                        cycle_counter <= 12'd0;

                        if (tick_counter > 0) begin
                            tick_counter <= tick_counter - 5'd1;

                            if (tick_counter == 5'd1) begin
                                // This was last 1000-cycle chunk, counting done next cycle
                                state <= WAIT_ACK;
                                counting <= 1'b0;
                                done <= 1'b1;
                                count <= 4'd0;
                            end
                        end
                    end else begin
                        cycle_counter <= cycle_counter + 12'd1;
                    end
                end

                WAIT_ACK: begin
                    counting <= 1'b0;
                    done <= 1'b1;
                    count <= 4'd0;

                    // Clear pattern_shift to avoid stale data
                    pattern_shift <= 4'd0;

                    if (ack) begin
                        // On ack, reset all and go back to SEARCH
                        state <= SEARCH;
                        delay_reg <= 4'd0;
                        delay_bits_loaded <= 3'd0;
                        cycle_counter <= 12'd0;
                        tick_counter <= 5'd0;
                        done <= 1'b0;
                    end
                end

                default: begin
                    // Safety: reset to SEARCH state
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