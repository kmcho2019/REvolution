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

    reg [1:0] state;
    reg [3:0] pattern;
    reg [3:0] delay;
    reg [15:0] cycles;  // Handles up to 16*1000 = 16000 cycles

    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            pattern <= 4'b0;
            delay <= 4'b0;
            cycles <= 16'b0;
            count <= 4'b0;
            counting <= 1'b0;
            done <= 1'b0;
        end else begin
            case (state)
                IDLE: begin
                    pattern <= {pattern[2:0], data};
                    counting <= 1'b0;
                    done <= 1'b0;
                    
                    if (pattern == 4'b1101) begin
                        state <= CAPTURE;
                        pattern <= 4'b0;
                        delay <= 4'b0;
                    end
                end
                
                CAPTURE: begin
                    delay <= {delay[2:0], data};
                    
                    if (&delay[3:0]) begin  // After 4 bits captured
                        state <= COUNTING;
                        cycles <= (delay + 1) * 1000;
                        counting <= 1'b1;
                    end
                end
                
                COUNTING: begin
                    if (cycles > 0) begin
                        cycles <= cycles - 1;
                        count <= (cycles - 1) / 1000;  // Simple division
                    end else begin
                        counting <= 1'b0;
                        done <= 1'b1;
                        if (ack) begin
                            state <= IDLE;
                            done <= 1'b0;
                        end
                    end
                end
            endcase
        end
    end

endmodule