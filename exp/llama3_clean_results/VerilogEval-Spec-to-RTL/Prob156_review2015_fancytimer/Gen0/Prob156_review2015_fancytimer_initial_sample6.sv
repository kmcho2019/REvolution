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
reg [9:0] counter;
reg [3:0] remaining;
reg [3:0] pattern;

always @(posedge clk) begin
    if (reset) begin
        counting <= 0;
        done <= 0;
        pattern <= 0;
        counter <= 0;
        remaining <= 0;
        delay <= 0;
    end else begin
        case (pattern)
            4'b0000: begin // idle
                if (data == 1) begin
                    pattern <= {pattern[2:0], 1};
                end else if (data == 0 && pattern == 4'b1101) begin
                    pattern <= 4'b0001;
                end else if (data == 0) begin
                    pattern <= {pattern[2:0], 0};
                end
            end
            4'b0001: begin // pattern detected, start shifting
                if (data == 1) begin
                    delay <= {delay[2:0], 1};
                end else begin
                    delay <= {delay[2:0], 0};
                end
                pattern <= pattern + 1;
                if (pattern == 4'b1101) begin
                    remaining <= delay;
                    counter <= 0;
                    counting <= 1;
                    pattern <= 4'b1111; // counting state
                end
            end
            4'b1111: begin // counting
                if (counter == 1000) begin
                    remaining <= remaining - 1;
                    counter <= 0;
                    if (remaining == 0) begin
                        pattern <= 4'b1110; // done state
                    end
                end else begin
                    counter <= counter + 1;
                end
                count <= remaining;
            end
            4'b1110: begin // done
                done <= 1;
                if (ack) begin
                    done <= 0;
                    pattern <= 4'b0000; // reset to idle state
                end
            end
            default: pattern <= pattern;
        endcase
    end
end

endmodule