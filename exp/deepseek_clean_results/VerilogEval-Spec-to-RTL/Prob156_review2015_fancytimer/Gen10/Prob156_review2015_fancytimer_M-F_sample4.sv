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
    
    state_t state, next_state;
    
    // Pattern detection
    reg [3:0] pattern_buffer;
    wire pattern_match = (pattern_buffer == 4'b1101);
    
    // Delay capture
    reg [3:0] delay_value;
    reg [1:0] bit_counter;
    
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
            cycle_counter <= 0;
            period_counter <= 0;
            bit_counter <= 0;
            delay_value <= 0;
        end else begin
            state <= next_state;
            
            case (state)
                SEARCH: begin
                    pattern_buffer <= {pattern_buffer[2:0], data};
                    counting <= 0;
                    done <= 0;
                end
                
                CAPTURE_DELAY: begin
                    if (bit_counter < 3) begin
                        delay_value <= {delay_value[2:0], data};
                        bit_counter <= bit_counter + 1;
                    end
                end
                
                COUNT_DOWN: begin
                    if (cycle_counter < 999) begin
                        cycle_counter <= cycle_counter + 1;
                    end else begin
                        cycle_counter <= 0;
                        period_counter <= period_counter - 1;
                        count <= period_counter - 1;
                    end
                end
                
                WAIT_ACK: begin
                    // Hold done until ack
                end
            endcase
        end
    end

    // Next state logic
    always @(*) begin
        next_state = state;
        
        case (state)
            SEARCH: begin
                if (pattern_match) begin
                    next_state = CAPTURE_DELAY;
                end
            end
            
            CAPTURE_DELAY: begin
                if (bit_counter == 3) begin
                    next_state = COUNT_DOWN;
                end
            end
            
            COUNT_DOWN: begin
                if (cycle_counter == 999 && period_counter == 0) begin
                    next_state = WAIT_ACK;
                end
            end
            
            WAIT_ACK: begin
                if (ack) begin
                    next_state = SEARCH;
                end
            end
        endcase
    end

    // Output logic
    always @(posedge clk) begin
        if (reset) begin
            counting <= 0;
            done <= 0;
            count <= 4'b0;
        end else begin
            case (next_state)
                SEARCH: begin
                    counting <= 0;
                    done <= 0;
                end
                
                CAPTURE_DELAY: begin
                    counting <= 0;
                    done <= 0;
                end
                
                COUNT_DOWN: begin
                    if (state != COUNT_DOWN) begin
                        // Initialize counters when entering COUNT_DOWN
                        counting <= 1;
                        cycle_counter <= 0;
                        period_counter <= delay_value;
                        count <= delay_value;
                    end
                end
                
                WAIT_ACK: begin
                    if (state != WAIT_ACK) begin
                        counting <= 0;
                        done <= 1;
                    end
                end
            endcase
        end
    end

endmodule