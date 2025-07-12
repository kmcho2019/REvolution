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
    localparam IDLE     = 0;
    localparam COUNTING = 1;
    localparam DONE     = 2;

    reg [1:0] state;
    reg [3:0] delay;
    reg [15:0] counter; // For counting up to (15+1)*1000 = 16000 cycles
    reg [2:0] bit_cnt;

    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            counting <= 0;
            done <= 0;
            count <= 0;
            delay <= 0;
            counter <= 0;
            bit_cnt <= 0;
        end else begin
            case (state)
                IDLE: begin
                    done <= 0;
                    // Shift in pattern/delay bits
                    delay <= {delay[2:0], data};
                    counter <= counter + 1;
                    
                    // Check for pattern 1101 (first 4 bits)
                    if (counter == 3 && delay == 4'b1101) begin
                        bit_cnt <= 0;
                        counter <= 0;
                    end
                    // After pattern, capture next 4 bits as delay
                    else if (counter >= 4 && bit_cnt < 4) begin
                        bit_cnt <= bit_cnt + 1;
                        if (bit_cnt == 3) begin
                            state <= COUNTING;
                            counting <= 1;
                            counter <= 0;
                            count <= delay; // Initial count value
                        end
                    end
                end
                
                COUNTING: begin
                    counter <= counter + 1;
                    // Update count every 1000 cycles
                    if (counter == 999) begin
                        counter <= 0;
                        count <= count - 1;
                        // Check if counting complete
                        if (count == 0) begin
                            state <= DONE;
                            counting <= 0;
                            done <= 1;
                        end
                    end
                end
                
                DONE: begin
                    if (ack) begin
                        state <= IDLE;
                        done <= 0;
                        counter <= 0;
                    end
                end
            endcase
        end
    end

endmodule