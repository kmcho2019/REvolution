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
    localparam S_IDLE        = 2'b00;
    localparam S_CAPTURE     = 2'b01;
    localparam S_COUNTING    = 2'b10;
    localparam S_WAIT_ACK    = 2'b11;

    reg [1:0] state;
    reg [3:0] pattern_reg;
    reg [3:0] delay_reg;
    reg [2:0] bit_count;
    reg [9:0] cycle_counter;  // Counts 0-999 (1000 cycles)
    reg [3:0] delay_counter;  // Counts down delay value
    reg pattern_matched;

    always @(posedge clk) begin
        if (reset) begin
            state <= S_IDLE;
            pattern_reg <= 4'b0;
            delay_reg <= 4'b0;
            bit_count <= 0;
            cycle_counter <= 0;
            delay_counter <= 0;
            counting <= 0;
            done <= 0;
            count <= 4'b0;
            pattern_matched <= 0;
        end else begin
            case (state)
                S_IDLE: begin
                    // Shift in data and check for pattern
                    pattern_reg <= {pattern_reg[2:0], data};
                    
                    if (pattern_reg == 4'b1101 && !pattern_matched) begin
                        pattern_matched <= 1;
                        state <= S_CAPTURE;
                        bit_count <= 0;
                    end
                    
                    counting <= 0;
                    done <= 0;
                end

                S_CAPTURE: begin
                    // Capture 4-bit delay value MSB first
                    delay_reg <= {delay_reg[2:0], data};
                    bit_count <= bit_count + 1;
                    
                    if (bit_count == 3) begin
                        delay_counter <= {delay_reg[2:0], data};
                        cycle_counter <= 0;
                        state <= S_COUNTING;
                        counting <= 1;
                        count <= {delay_reg[2:0], data};
                        pattern_matched <= 0;
                    end
                end

                S_COUNTING: begin
                    cycle_counter <= cycle_counter + 1;
                    
                    if (cycle_counter == 999) begin
                        cycle_counter <= 0;
                        if (delay_counter == 0) begin
                            state <= S_WAIT_ACK;
                            counting <= 0;
                            done <= 1;
                        end else begin
                            delay_counter <= delay_counter - 1;
                            count <= delay_counter - 1;
                        end
                    end
                end

                S_WAIT_ACK: begin
                    if (ack) begin
                        state <= S_IDLE;
                        done <= 0;
                        pattern_reg <= 4'b0;
                    end
                end
            endcase
        end
    end

endmodule