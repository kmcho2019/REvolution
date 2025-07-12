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
    typedef enum logic [1:0] {
        IDLE,
        CAPTURE_DELAY,
        COUNTING,
        DONE
    } state_t;

    state_t state, next_state;

    // Pattern detection
    reg [3:0] pattern_reg;
    reg pattern_matched;

    // Delay capture
    reg [3:0] delay;
    reg [2:0] delay_bits_captured;

    // Counters
    reg [15:0] main_counter; // Enough for 16*1000 = 16000 cycles
    reg [9:0] cycle_counter; // Counts 0-999 for each delay step

    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            pattern_reg <= 4'b0;
            pattern_matched <= 0;
            delay <= 4'b0;
            delay_bits_captured <= 0;
            counting <= 0;
            done <= 0;
            count <= 4'b0;
            main_counter <= 0;
            cycle_counter <= 0;
        end else begin
            case (state)
                IDLE: begin
                    // Shift in data to detect pattern 1101
                    pattern_reg <= {pattern_reg[2:0], data};
                    counting <= 0;
                    done <= 0;
                    
                    if (pattern_reg == 4'b1101) begin
                        state <= CAPTURE_DELAY;
                        delay_bits_captured <= 0;
                    end
                end

                CAPTURE_DELAY: begin
                    // Shift in next 4 bits for delay value
                    if (delay_bits_captured < 4) begin
                        delay <= {delay[2:0], data};
                        delay_bits_captured <= delay_bits_captured + 1;
                    end
                    
                    if (delay_bits_captured == 3) begin
                        state <= COUNTING;
                        counting <= 1;
                        main_counter <= (delay + 1) * 1000;
                        cycle_counter <= 0;
                        count <= delay;
                    end
                end

                COUNTING: begin
                    if (main_counter > 0) begin
                        main_counter <= main_counter - 1;
                        cycle_counter <= cycle_counter + 1;
                        
                        // Update count every 1000 cycles
                        if (cycle_counter == 999) begin
                            cycle_counter <= 0;
                            if (count > 0) begin
                                count <= count - 1;
                            end
                        end
                    end else begin
                        state <= DONE;
                        counting <= 0;
                        done <= 1;
                    end
                end

                DONE: begin
                    if (ack) begin
                        state <= IDLE;
                        done <= 0;
                        pattern_reg <= 4'b0;
                        count <= 4'b0;
                    end
                end
            endcase
        end
    end

endmodule