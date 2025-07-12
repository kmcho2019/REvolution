module TopModule (
    input clk,
    input reset,
    input data,
    output reg [3:0] count,
    output reg counting,
    output reg done,
    input ack
);

    // Simplified FSM states
    localparam DETECT   = 1'b0;
    localparam COUNTING = 1'b1;
    
    reg state, next_state;
    reg [3:0] pattern_reg;  // For 1101 detection
    reg [3:0] delay_reg;    // Also used as countdown value
    reg [1:0] bit_count;    // Only needs 2 bits (counts 0-3)
    reg [9:0] cycle_count;  // 10-bit counter for 1000 cycles

    // State transition and pattern detection
    always @(posedge clk) begin
        if (reset) begin
            state <= DETECT;
            pattern_reg <= 4'b0;
            delay_reg <= 4'b0;
            bit_count <= 2'b0;
            cycle_count <= 10'b0;
        end else begin
            state <= next_state;
            
            case (state)
                DETECT: begin
                    pattern_reg <= {pattern_reg[2:0], data};
                    if (bit_count < 3) bit_count <= bit_count + 1;
                end
                
                COUNTING: begin
                    if (cycle_count == 999) begin
                        cycle_count <= 0;
                        if (delay_reg != 0) delay_reg <= delay_reg - 1;
                    end else begin
                        cycle_count <= cycle_count + 1;
                    end
                end
            endcase
        end
    end

    // Next state logic
    always @(*) begin
        case (state)
            DETECT: begin
                if (pattern_reg == 4'b1101 && bit_count == 3)
                    next_state = COUNTING;
                else
                    next_state = DETECT;
            end
            
            COUNTING: begin
                if (delay_reg == 0 && cycle_count == 999)
                    next_state = DETECT;
                else
                    next_state = COUNTING;
            end
        endcase
    end

    // Output logic
    always @(*) begin
        counting = (state == COUNTING);
        done = (delay_reg == 0 && cycle_count == 999);
        count = (state == COUNTING) ? delay_reg : 4'b0;
    end

    // Handle ack to reset detection
    always @(posedge clk) begin
        if (done && ack) begin
            state <= DETECT;
            pattern_reg <= 4'b0;
            bit_count <= 2'b0;
        end
    end

endmodule