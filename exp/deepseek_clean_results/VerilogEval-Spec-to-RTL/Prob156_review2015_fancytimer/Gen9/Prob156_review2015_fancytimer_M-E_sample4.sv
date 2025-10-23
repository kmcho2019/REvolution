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
    typedef enum {
        SEARCH,
        CAPTURE_DELAY,
        COUNT_DOWN,
        WAIT_ACK
    } state_t;
    
    state_t state;
    
    // Pattern detection
    reg [3:0] pattern_buffer;
    wire pattern_match = (pattern_buffer == 4'b1101);
    
    // Delay capture
    reg [3:0] delay_value;
    reg [2:0] bit_counter;
    
    // Timing counters
    reg [9:0] cycle_counter;  // Counts 0-999 (1000 cycles)
    reg [3:0] period_counter; // Counts delay periods
    
    always @(posedge clk) begin
        if (reset) begin
            state <= SEARCH;
            pattern_buffer <= 4'b0;
            counting <= 0;
            done <= 0;
            count <= 4'b0;
        end else begin
            case (state)
                SEARCH: begin
                    pattern_buffer <= {pattern_buffer[2:0], data};
                    counting <= 0;
                    done <= 0;
                    
                    if (pattern_match) begin
                        state <= CAPTURE_DELAY;
                        bit_counter <= 0;
                    end
                end
                
                CAPTURE_DELAY: begin
                    delay_value <= {delay_value[2:0], data};
                    bit_counter <= bit_counter + 1;
                    
                    if (bit_counter == 3) begin
                        state <= COUNT_DOWN;
                        cycle_counter <= 0;
                        period_counter <= delay_value;
                        counting <= 1;
                    end
                end
                
                COUNT_DOWN: begin
                    cycle_counter <= cycle_counter + 1;
                    
                    if (cycle_counter == 999) begin
                        cycle_counter <= 0;
                        period_counter <= period_counter - 1;
                        
                        if (period_counter == 0) begin
                            state <= WAIT_ACK;
                            counting <= 0;
                            done <= 1;
                        end
                    end
                    
                    count <= period_counter;
                end
                
                WAIT_ACK: begin
                    if (ack) begin
                        state <= SEARCH;
                        done <= 0;
                        pattern_buffer <= 4'b0;
                    end
                end
            endcase
        end
    end

endmodule