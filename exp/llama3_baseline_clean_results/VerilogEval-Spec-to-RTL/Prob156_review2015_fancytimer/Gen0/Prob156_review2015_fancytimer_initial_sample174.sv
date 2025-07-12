module TopModule(
    input  clk,
    input  reset,
    input  data,
    output reg [3:0] count,
    output reg counting,
    output reg done,
    input  ack
);

reg [3:0] delay;
reg [3:0] shiftReg;
reg [9:0] counter;
reg [3:0] patternDetector;
reg [1:0] state;
reg patternDetected;

always @(posedge clk) begin
    if (reset) begin
        state <= 2'b00; // Idle state
        patternDetector <= 4'b0000;
        shiftReg <= 4'b0000;
        counter <= 10'b0000000000;
        count <= 4'b0000;
        counting <= 1'b0;
        done <= 1'b0;
        patternDetected <= 1'b0;
    end else begin
        case (state)
            2'b00: begin // Idle state
                if (patternDetected) begin
                    state <= 2'b01; // PatternDetected state
                    patternDetected <= 1'b0;
                end else begin
                    if (data) begin
                        patternDetector <= {patternDetector[2:0], 1'b1};
                    end else begin
                        patternDetector <= {patternDetector[2:0], 1'b0};
                    end
                    if (patternDetector == 4'b1101) begin
                        patternDetected <= 1'b1;
                    end
                end
            end
            2'b01: begin // PatternDetected state
                state <= 2'b10; // ShiftDelay state
                shiftReg <= 4'b0000;
            end
            2'b10: begin // ShiftDelay state
                shiftReg <= {data, shiftReg[3:1]};
                if (shiftReg[0]) begin
                    state <= 2'b11; // Counting state
                    delay <= shiftReg;
                    counter <= 10'b0000000000;
                    count <= delay;
                    counting <= 1'b1;
                end
            end
            2'b11: begin // Counting state
                counter <= counter + 1;
                if (counter == 10'b1111101000) begin
                    counter <= 10'b0000000000;
                    count <= count - 1;
                    if (count == 4'b0000) begin
                        state <= 2'b00; // Done state
                        counting <= 1'b0;
                        done <= 1'b1;
                    end
                end
            end
            default: begin
                if (ack) begin
                    state <= 2'b00; // Idle state
                    done <= 1'b0;
                end
            end
        endcase
    end
end

endmodule