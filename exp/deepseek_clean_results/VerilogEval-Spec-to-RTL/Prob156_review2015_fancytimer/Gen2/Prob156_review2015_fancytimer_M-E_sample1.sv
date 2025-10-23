module TopModule (
    input clk,
    input reset,
    input data,
    output reg [3:0] count,
    output reg counting,
    output reg done,
    input ack
);

    // Pattern matching FSM states
    localparam PM_IDLE = 0;
    localparam PM_MATCHING = 1;
    localparam PM_CAPTURE = 2;
    
    // Timing FSM states
    localparam TM_IDLE = 0;
    localparam TM_COUNTING = 1;
    localparam TM_DONE = 2;

    reg pm_state;
    reg tm_state;
    
    // Pattern matching registers
    reg [3:0] pattern_reg;
    reg [2:0] bit_counter;
    reg [3:0] delay_reg;
    reg pattern_found;
    
    // Timing registers
    reg [13:0] cycle_counter;
    reg [9:0] prescaler;
    reg [3:0] current_delay;
    
    always @(posedge clk) begin
        if (reset) begin
            // Reset pattern matching
            pm_state <= PM_IDLE;
            pattern_reg <= 4'b0;
            bit_counter <= 3'b0;
            delay_reg <= 4'b0;
            pattern_found <= 1'b0;
            
            // Reset timing
            tm_state <= TM_IDLE;
            cycle_counter <= 14'b0;
            prescaler <= 10'b0;
            current_delay <= 4'b0;
            
            // Reset outputs
            counting <= 1'b0;
            done <= 1'b0;
            count <= 4'b0;
        end else begin
            // Pattern matching FSM
            case (pm_state)
                PM_IDLE: begin
                    pattern_reg <= {pattern_reg[2:0], data};
                    if (pattern_reg == 4'b1101) begin
                        pm_state <= PM_CAPTURE;
                        bit_counter <= 3'b0;
                    end
                end
                
                PM_CAPTURE: begin
                    if (bit_counter == 3'd4) begin
                        pm_state <= PM_IDLE;
                        pattern_found <= 1'b1;
                    end else begin
                        delay_reg <= {delay_reg[2:0], data};
                        bit_counter <= bit_counter + 1;
                    end
                end
            endcase
            
            // Timing FSM
            case (tm_state)
                TM_IDLE: begin
                    if (pattern_found) begin
                        tm_state <= TM_COUNTING;
                        current_delay <= delay_reg;
                        cycle_counter <= 14'b0;
                        prescaler <= 10'b0;
                        counting <= 1'b1;
                        pattern_found <= 1'b0;
                    end
                end
                
                TM_COUNTING: begin
                    if (prescaler == 10'd999) begin
                        prescaler <= 10'b0;
                        if (current_delay == 4'b0) begin
                            tm_state <= TM_DONE;
                            counting <= 1'b0;
                            done <= 1'b1;
                        end else begin
                            current_delay <= current_delay - 1;
                        end
                    end else begin
                        prescaler <= prescaler + 1;
                    end
                    
                    count <= current_delay;
                    cycle_counter <= cycle_counter + 1;
                end
                
                TM_DONE: begin
                    if (ack) begin
                        tm_state <= TM_IDLE;
                        done <= 1'b0;
                    end
                end
            endcase
        end
    end

endmodule