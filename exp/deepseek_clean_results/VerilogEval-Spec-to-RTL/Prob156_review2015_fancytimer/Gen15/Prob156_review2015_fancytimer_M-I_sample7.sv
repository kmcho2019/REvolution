module TopModule (
    input clk,
    input reset,
    input data,
    output reg [3:0] count,
    output reg counting,
    output reg done,
    input ack
);

    // State encoding
    localparam IDLE     = 2'b00;
    localparam CAPTURE  = 2'b01;
    localparam COUNTING = 2'b10;
    localparam DONE     = 2'b11;

    reg [1:0] state;
    reg [3:0] pattern_reg;
    reg [3:0] delay_reg;
    reg [13:0] cycle_counter;  // Handles up to 16,000 cycles (14 bits)
    reg [1:0] bit_counter;

    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            pattern_reg <= 4'b0;
            delay_reg <= 4'b0;
            cycle_counter <= 14'b0;
            bit_counter <= 2'b0;
            count <= 4'b0;
            counting <= 1'b0;
            done <= 1'b0;
        end else begin
            case (state)
                IDLE: begin
                    // Shift in data to detect pattern 1101
                    pattern_reg <= {pattern_reg[2:0], data};
                    counting <= 1'b0;
                    done <= 1'b0;
                    count <= 4'b0;
                    
                    if (pattern_reg == 4'b1101) begin
                        state <= CAPTURE;
                        bit_counter <= 2'b0;
                        pattern_reg <= 4'b0;  // Clear pattern after detection
                    end
                end
                
                CAPTURE: begin
                    // Shift in next 4 bits for delay value
                    delay_reg <= {delay_reg[2:0], data};
                    
                    if (bit_counter == 2'b11) begin
                        state <= COUNTING;
                        cycle_counter <= 14'b0;
                        counting <= 1'b1;
                    end else begin
                        bit_counter <= bit_counter + 1;
                    end
                end
                
                COUNTING: begin
                    // Calculate remaining time in multiples of 1000 cycles
                    count <= ((delay_reg + 1) * 1000 - cycle_counter - 1) / 1000;
                    
                    if (cycle_counter == (delay_reg + 1) * 1000 - 1) begin
                        state <= DONE;
                        counting <= 1'b0;
                        done <= 1'b1;
                    end else begin
                        cycle_counter <= cycle_counter + 1;
                    end
                end
                
                DONE: begin
                    if (ack) begin
                        state <= IDLE;
                        done <= 1'b0;
                    end
                end
            endcase
        end
    end

endmodule