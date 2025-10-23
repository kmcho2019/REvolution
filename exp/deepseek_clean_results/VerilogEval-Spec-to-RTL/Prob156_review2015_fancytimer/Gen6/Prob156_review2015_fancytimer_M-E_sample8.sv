module TopModule (
    input clk,
    input reset,
    input data,
    output reg [3:0] count,
    output reg counting,
    output reg done,
    input ack
);

    // One-hot state encoding
    localparam S_IDLE        = 5'b00001;
    localparam S_PATTERN     = 5'b00010;
    localparam S_CAPTURE     = 5'b00100;
    localparam S_COUNTING    = 5'b01000;
    localparam S_WAIT_ACK    = 5'b10000;

    reg [4:0] state;
    reg [3:0] pattern_shifter;
    reg [3:0] delay_shifter;
    reg [2:0] bit_counter;
    reg [15:0] main_counter;
    reg [9:0] sub_counter;
    reg [3:0] delay_value;

    always @(posedge clk) begin
        if (reset) begin
            state <= S_IDLE;
            pattern_shifter <= 4'b0;
            delay_shifter <= 4'b0;
            bit_counter <= 0;
            main_counter <= 0;
            sub_counter <= 0;
            counting <= 0;
            done <= 0;
            count <= 4'b0;
            delay_value <= 4'b0;
        end else begin
            case (state)
                S_IDLE: begin
                    // Shift in data and check for pattern
                    pattern_shifter <= {pattern_shifter[2:0], data};
                    if (pattern_shifter[2:0] == 3'b110 && data == 1'b1) begin
                        state <= S_PATTERN;
                    end
                    counting <= 0;
                    done <= 0;
                end

                S_PATTERN: begin
                    // Confirm full pattern 1101
                    if (pattern_shifter == 4'b1101) begin
                        state <= S_CAPTURE;
                        bit_counter <= 0;
                    end else begin
                        state <= S_IDLE;
                    end
                end

                S_CAPTURE: begin
                    // Capture 4-bit delay value
                    delay_shifter <= {delay_shifter[2:0], data};
                    bit_counter <= bit_counter + 1;
                    
                    if (bit_counter == 3) begin
                        delay_value <= {delay_shifter[2:0], data};
                        // Calculate (delay+1)*1000
                        main_counter <= ({delay_shifter[2:0], data} + 1) * 1000 - 1;
                        sub_counter <= 0;
                        count <= {delay_shifter[2:0], data};
                        state <= S_COUNTING;
                        counting <= 1;
                    end
                end

                S_COUNTING: begin
                    if (main_counter == 0) begin
                        state <= S_WAIT_ACK;
                        counting <= 0;
                        done <= 1;
                    end else begin
                        main_counter <= main_counter - 1;
                        sub_counter <= sub_counter + 1;
                        
                        // Update count every 1000 cycles
                        if (sub_counter == 999) begin
                            count <= count - 1;
                            sub_counter <= 0;
                        end
                    end
                end

                S_WAIT_ACK: begin
                    if (ack) begin
                        state <= S_IDLE;
                        done <= 0;
                        pattern_shifter <= 4'b0;
                    end
                end
            endcase
        end
    end

endmodule