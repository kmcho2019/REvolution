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
        end else begin
            state <= next_state;
            
            case (state)
                IDLE: begin
                    pattern_reg <= {pattern_reg[2:0], data};
                end
                
                SHIFT_DELAY: begin
                    if (bit_count < 3) begin
                        delay_reg <= {delay_reg[2:0], data};
                        bit_count <= bit_count + 1;
                    end else begin
                        delay_reg <= {delay_reg[2:0], data};  // Final bit
                        delay_counter <= {delay_reg[2:0], data};
                    end
                end
                
                COUNTING: begin
                    if (cycle_counter == 999) begin
                        cycle_counter <= 0;
                        if (delay_counter != 0)
                            delay_counter <= delay_counter - 1;
                    end else begin
                        cycle_counter <= cycle_counter + 1;
                    end
                end
                
                DONE: begin
                    if (ack) begin
                        pattern_reg <= 4'b0;
                        bit_count <= 2'b0;
                    end
                end
            endcase
        end
    end

    // Next state logic
    always @(*) begin
        case (state)
            IDLE: begin
                if (pattern_reg == 4'b1101)
                    next_state = SHIFT_DELAY;
                else
                    next_state = IDLE;
            end
            
            SHIFT_DELAY: begin
                if (bit_count == 3)
                    next_state = COUNTING;
                else
                    next_state = SHIFT_DELAY;
            end
            
            COUNTING: begin
                if (delay_counter == 0 && cycle_counter == 999)
                    next_state = DONE;
                else
                    next_state = COUNTING;
            end
            
            DONE: begin
                if (ack)
                    next_state = IDLE;
                else
                    next_state = DONE;
            end
            
            default: next_state = IDLE;
        endcase
    end

    // Output logic
    always @(*) begin
        counting = (state == COUNTING);
        done = (state == DONE);
        count = (state == COUNTING) ? delay_counter : 4'b0;
    end

endmodule