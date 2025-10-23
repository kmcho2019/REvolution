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
    localparam IDLE       = 2'b00;
    localparam READ_DELAY = 2'b01;
    localparam COUNTING   = 2'b10;
    localparam DONE       = 2'b11;

    reg [1:0] state, next_state;
    reg [3:0] pattern_reg;  // Shift register for pattern detection
    reg [3:0] delay_reg;    // Shift register for delay value
    reg [3:0] delay_value;  // Captured delay value
    reg [9:0] cycle_counter; // Counts 0-999 (1000 cycles)
    reg [3:0] period_counter; // Counts remaining periods
    reg [1:0] bit_counter;   // Counts bits read during READ_DELAY

    // State transition and main logic
    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            pattern_reg <= 4'b0;
            delay_reg <= 4'b0;
            delay_value <= 4'b0;
            cycle_counter <= 0;
            period_counter <= 0;
            bit_counter <= 0;
            counting <= 0;
            done <= 0;
            count <= 4'b0;
        end else begin
            case (state)
                IDLE: begin
                    // Shift in new data for pattern detection
                    pattern_reg <= {pattern_reg[2:0], data};
                    counting <= 0;
                    done <= 0;
                    
                    // When pattern 1101 is detected
                    if (pattern_reg == 4'b1101) begin
                        state <= READ_DELAY;
                        bit_counter <= 0;
                        delay_reg <= 4'b0;  // Clear delay register
                        pattern_reg <= 4'b0; // Clear pattern to prevent re-trigger
                    end
                end

                READ_DELAY: begin
                    // Shift in next 4 bits (MSB first)
                    delay_reg <= {delay_reg[2:0], data};
                    
                    if (bit_counter == 3) begin
                        // After 4 bits, capture delay value
                        delay_value <= {delay_reg[2:0], data};
                        period_counter <= {delay_reg[2:0], data};
                        state <= COUNTING;
                        cycle_counter <= 0;
                        counting <= 1;
                    end else begin
                        bit_counter <= bit_counter + 1;
                    end
                end

                COUNTING: begin
                    if (cycle_counter == 999) begin
                        // Completed 1000 cycles
                        cycle_counter <= 0;
                        
                        if (period_counter == 0) begin
                            // Completed all periods
                            state <= DONE;
                            counting <= 0;
                            done <= 1;
                        end else begin
                            // Decrement period counter
                            period_counter <= period_counter - 1;
                        end
                    end else begin
                        cycle_counter <= cycle_counter + 1;
                    end
                    
                    // Output current remaining periods
                    count <= period_counter;
                end

                DONE: begin
                    // Wait for acknowledgement
                    if (ack) begin
                        state <= IDLE;
                        done <= 0;
                    end
                end
            endcase
        end
    end
endmodule