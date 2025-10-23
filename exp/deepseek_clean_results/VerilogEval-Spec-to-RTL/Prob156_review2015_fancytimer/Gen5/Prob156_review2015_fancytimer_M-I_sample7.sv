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
    typedef enum {
        IDLE,
        CAPTURE_DELAY,
        COUNTING,
        DONE
    } state_t;
    
    reg [1:0] state;
    reg [3:0] pattern_reg;
    reg [3:0] delay_val;
    reg [3:0] delay_counter;
    reg [9:0] cycle_counter;
    reg [1:0] bit_counter;

    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            pattern_reg <= 4'b0;
            delay_val <= 4'b0;
            delay_counter <= 4'b0;
            cycle_counter <= 10'b0;
            bit_counter <= 2'b0;
            counting <= 1'b0;
            done <= 1'b0;
            count <= 4'b0;
        end else begin
            case (state)
                IDLE: begin
                    // Shift in data for pattern detection
                    pattern_reg <= {pattern_reg[2:0], data};
                    done <= 1'b0;
                    
                    // When pattern matches, transition to capture delay
                    if (pattern_reg == 4'b1101) begin
                        state <= CAPTURE_DELAY;
                        bit_counter <= 2'b0;
                    end
                end
                
                CAPTURE_DELAY: begin
                    // Shift in next 4 bits for delay value
                    delay_val <= {delay_val[2:0], data};
                    bit_counter <= bit_counter + 1;
                    
                    if (bit_counter == 2'b11) begin
                        state <= COUNTING;
                        counting <= 1'b1;
                        delay_counter <= delay_val;
                        cycle_counter <= 10'b0;
                    end
                end
                
                COUNTING: begin
                    if (cycle_counter == 10'd999) begin
                        cycle_counter <= 10'b0;
                        delay_counter <= delay_counter - 1;
                        
                        if (delay_counter == 4'b0) begin
                            state <= DONE;
                            counting <= 1'b0;
                            done <= 1'b1;
                        end
                    end else begin
                        cycle_counter <= cycle_counter + 1;
                    end
                    
                    // Output current countdown value
                    count <= delay_counter;
                end
                
                DONE: begin
                    if (ack) begin
                        state <= IDLE;
                        pattern_reg <= 4'b0;
                        delay_val <= 4'b0;
                    end
                end
            endcase
        end
    end

endmodule