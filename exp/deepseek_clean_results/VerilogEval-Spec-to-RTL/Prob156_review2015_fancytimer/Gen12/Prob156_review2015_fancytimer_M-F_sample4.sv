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
    localparam IDLE     = 2'b00;
    localparam CAPTURE  = 2'b01;
    localparam COUNTING = 2'b10;
    localparam DONE     = 2'b11;

    reg [1:0] state;
    reg [3:0] pattern_reg;    // For detecting 1101
    reg [3:0] delay_val;      // Captured delay value
    reg [3:0] periods_left;   // Tracks remaining periods
    reg [9:0] cycle_counter;  // Counts 0-999 cycles per period
    reg [2:0] bit_counter;    // Counts 0-4 bits for capture (needs extra bit)

    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            pattern_reg <= 4'b0;
            delay_val <= 4'b0;
            periods_left <= 4'b0;
            cycle_counter <= 0;
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
                    count <= 4'b0;
                    
                    // Detect pattern 1101 (MSB first)
                    if (pattern_reg == 4'b1101) begin
                        state <= CAPTURE;
                        bit_counter <= 0;
                        delay_val <= 4'b0;  // Clear previous delay value
                    end
                end
                
                CAPTURE: begin
                    // Shift in next 4 bits for delay value (MSB first)
                    delay_val <= {delay_val[2:0], data};
                    
                    if (bit_counter == 3) begin
                        // After capturing all 4 bits, initialize counters
                        periods_left <= delay_val;  // Use fully captured value
                        cycle_counter <= 0;
                        counting <= 1;
                        count <= delay_val;  // Initial count value
                        state <= COUNTING;
                    end
                    bit_counter <= bit_counter + 1;
                end
                
                COUNTING: begin
                    if (cycle_counter == 999) begin
                        // Completed 1000 cycles for current period
                        cycle_counter <= 0;
                        
                        if (periods_left == 0) begin
                            // Completed all periods
                            counting <= 0;
                            done <= 1;
                            state <= DONE;
                        end else begin
                            // Move to next period
                            periods_left <= periods_left - 1;
                            count <= periods_left - 1; // Update count output
                        end
                    end else begin
                        cycle_counter <= cycle_counter + 1;
                    end
                end
                
                DONE: begin
                    if (ack) begin
                        // Acknowledgment received, return to IDLE
                        done <= 0;
                        pattern_reg <= 4'b0;
                        state <= IDLE;
                    end
                end
            endcase
        end
    end

endmodule