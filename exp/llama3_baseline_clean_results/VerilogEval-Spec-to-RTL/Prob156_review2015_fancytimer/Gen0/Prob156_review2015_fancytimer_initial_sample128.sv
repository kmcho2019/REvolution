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
reg [3:0] remaining;
reg [3:0] pattern;
reg pattern_detected;
reg [2:0] state; // 0: idle, 1: pattern detection, 2: delay loading, 3: counting, 4: done
reg [9:0] counter; // counts 1000 cycles

always @(posedge clk or posedge reset) begin
    if (reset) begin
        state <= 0;
        pattern_detected <= 0;
        delay <= 0;
        remaining <= 0;
        count <= 0;
        counting <= 0;
        done <= 0;
        pattern <= 0;
        counter <= 0;
    end else begin
        case (state)
            0: begin // idle
                if (data == 1) begin // start of pattern
                    state <= 1;
                    pattern <= 8; // shift in the first bit
                end
            end
            1: begin // pattern detection
                pattern <= {pattern[2:0], data};
                if (pattern == 9'b1101) begin
                    pattern_detected <= 1;
                    state <= 2;
                end else if (pattern[3:0] != 4'b1101) begin
                    state <= 0;
                end
            end
            2: begin // delay loading
                delay <= {delay[2:0], data};
                if (delay[3:0] == 4'b1000) begin // most significant bit is set
                    state <= 3;
                    remaining <= delay;
                    counting <= 1;
                end
            end
            3: begin // counting
                if (counter == 1000) begin
                    counter <= 0;
                    remaining <= remaining - 1;
                    if (remaining == 0) begin
                        state <= 4;
                        counting <= 0;
                        done <= 1;
                    end
                end else begin
                    counter <= counter + 1;
                end
                count <= remaining;
            end
            4: begin // done
                if (ack) begin
                    state <= 0;
                    done <= 0;
                end
            end
        endcase
    end
end

endmodule