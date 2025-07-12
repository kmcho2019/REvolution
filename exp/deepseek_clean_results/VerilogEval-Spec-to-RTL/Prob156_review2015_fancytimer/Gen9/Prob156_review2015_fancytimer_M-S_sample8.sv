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
    localparam IDLE = 0;
    localparam CAPTURE = 1;
    localparam COUNT = 2;
    localparam DONE = 3;
    
    reg [1:0] state;
    reg [3:0] pattern;
    reg [3:0] delay;
    reg [13:0] counter; // Enough for (15+1)*1000 = 16000 cycles
    reg [2:0] bit_cnt;

    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            pattern <= 4'b0;
            delay <= 4'b0;
            counter <= 14'b0;
            bit_cnt <= 3'b0;
            counting <= 1'b0;
            done <= 1'b0;
            count <= 4'b0;
        end else begin
            case (state)
                IDLE: begin
                    counting <= 1'b0;
                    done <= 1'b0;
                    pattern <= {pattern[2:0], data};
                    
                    if (pattern == 4'b1101) begin
                        state <= CAPTURE;
                        bit_cnt <= 3'b0;
                        pattern <= 4'b0; // Clear to prevent retrigger
                    end
                end
                
                CAPTURE: begin
                    delay <= {delay[2:0], data};
                    bit_cnt <= bit_cnt + 1;
                    
                    if (bit_cnt == 3'b11) begin
                        state <= COUNT;
                        counting <= 1'b1;
                        counter <= (delay + 1) * 1000 - 1; // Pre-calculate total cycles
                        count <= delay;
                    end
                end
                
                COUNT: begin
                    if (counter == 0) begin
                        state <= DONE;
                        counting <= 1'b0;
                        done <= 1'b1;
                    end else begin
                        counter <= counter - 1;
                        // Update count every 1000 cycles
                        if (counter % 1000 == 0)
                            count <= count - 1;
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