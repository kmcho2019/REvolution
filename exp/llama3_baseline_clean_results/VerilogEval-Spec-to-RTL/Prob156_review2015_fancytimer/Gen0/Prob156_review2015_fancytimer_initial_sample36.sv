module TopModule(
    input  clk,
    input  reset,
    input  data,
    output reg [3:0] count,
    output reg counting,
    output reg done,
    input  ack
);

reg [3:0] state; // 0: idle, 1: shift delay, 2: counting, 3: done
reg [3:0] delay; // delay value
reg [9:0] counter; // counter for counting down
reg [3:0] pattern; // shift register for pattern detection
reg detect; // flag to detect pattern

always @(posedge clk or posedge reset) begin
    if (reset) begin
        state <= 0;
        pattern <= 0;
        detect <= 0;
        delay <= 0;
        counter <= 0;
        count <= 0;
        counting <= 0;
        done <= 0;
    end else begin
        case (state)
            0: begin // idle
                if (detect) begin
                    state <= 1;
                    pattern <= 0;
                    detect <= 0;
                end else if (data) begin
                    pattern[0] <= 1;
                    pattern[3:1] <= pattern[2:0];
                    if (pattern == 4'b1101) begin
                        detect <= 1;
                    end else begin
                        pattern[3:1] <= pattern[2:0];
                    end
                end else begin
                    pattern[3:1] <= pattern[2:0];
                    pattern[0] <= 0;
                end
            end
            1: begin // shift delay
                delay[0] <= data;
                delay[3:1] <= delay[2:0];
                if (delay[3] == 1) begin
                    state <= 2;
                    counter <= ((delay + 1) * 1000) - 1;
                end
            end
            2: begin // counting
                if (counter == 0) begin
                    state <= 3;
                    done <= 1;
                end else begin
                    counter <= counter - 1;
                    if (counter % 1000 == 0) begin
                        count <= count - 1;
                    end
                    counting <= 1;
                end
            end
            3: begin // done
                if (ack) begin
                    state <= 0;
                    done <= 0;
                    counting <= 0;
                end
            end
        endcase
    end
end

endmodule