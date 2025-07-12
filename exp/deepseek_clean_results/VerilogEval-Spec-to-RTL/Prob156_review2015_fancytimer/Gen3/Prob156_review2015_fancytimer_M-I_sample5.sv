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
    localparam IDLE        = 2'b00;
    localparam SHIFT_DELAY = 2'b01;
    localparam COUNTING    = 2'b10;
    localparam DONE        = 2'b11;
    
    reg [1:0] state, next_state;
    reg [3:0] pattern_reg;    // For 1101 detection
    reg [3:0] delay_reg;      // Stored delay value
    reg [3:0] delay_counter;  // Countdown of delay intervals
    reg [1:0] bit_count;      // Counts bits for delay capture (0-3)
    reg [9:0] cycle_counter;  // Counts 0-999 for each delay interval

    // State transition
    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            pattern_reg <= 4'b0;
            delay_reg <= 4'b0;
            delay_counter <= 4'b0;
            bit_count <= 2'b0;
            cycle_counter <= 10'b0;
            counting <= 1'b0;
            done <= 1'b0;
            count <= 4'b0;
        end else begin
            state <= next_state;
            
            case (state)
                IDLE: begin
                    pattern_reg <= {pattern_reg[2:0], data};
                    counting <= 1'b0;
                    done <= 1'b0;
                    count <= 4'b0;
                end
                
                SHIFT_DELAY: begin
                    if (bit_count < 3) begin
                        delay_reg <= {delay_reg[2:0], data};
                        bit_count <= bit_count + 1;
                    end else begin
                        delay_reg <= {delay_reg[2:0], data};  // Final bit
                        delay_counter <= {delay_reg[2:0], data};
                        bit_count <= 2'b0;
                    end
                    counting <= 1'b0;
                    done <= 1'b0;
                end
                
                COUNTING: begin
                    if (cycle_counter == 10'd999) begin
                        cycle_counter <= 10'b0;
                        if (delay_counter != 0)
                            delay_counter <= delay_counter - 1;
                    end else begin
                        cycle_counter <= cycle_counter + 1;
                    end
                    counting <= 1'b1;
                    done <= 1'b0;
                    count <= delay_counter;
                end
                
                DONE: begin
                    if (ack) begin
                        pattern_reg <= 4'b0;
                        bit_count <= 2'b0;
                        cycle_counter <= 10'b0;
                    end
                    counting <= 1'b0;
                    done <= 1'b1;
                    count <= 4'b0;
                end
            endcase
        end
    end

    // Next state logic
    always @(*) begin
        case (state)
            IDLE: begin
                next_state = (pattern_reg == 4'b1101) ? SHIFT_DELAY : IDLE;
            end
            
            SHIFT_DELAY: begin
                next_state = (bit_count == 3) ? COUNTING : SHIFT_DELAY;
            end
            
            COUNTING: begin
                next_state = (delay_counter == 0 && cycle_counter == 10'd999) ? 
                            DONE : COUNTING;
            end
            
            DONE: begin
                next_state = ack ? IDLE : DONE;
            end
            
            default: next_state = IDLE;
        endcase
    end

endmodule