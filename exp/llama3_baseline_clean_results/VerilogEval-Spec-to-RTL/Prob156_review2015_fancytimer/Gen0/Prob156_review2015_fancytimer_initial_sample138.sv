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
reg [3:0] pattern;
reg pattern_match;

always @(posedge clk) begin
    if (reset) begin
        pattern <= 4'b0000;
        pattern_match <= 1'b0;
        delay <= 4'b0000;
        counter <= 10'b0000000000;
        count <= 4'b0000;
        counting <= 1'b0;
        done <= 1'b0;
    end else begin
        if (!pattern_match) begin
            pattern <= {pattern[2:0], data};
            if (pattern == 4'b1101) begin
                pattern_match <= 1'b1;
            end
        end else if (counter < 4) begin
            delay <= {delay[2:0], data};
            counter <= counter + 1;
        end else if (counter == 4) begin
            counting <= 1'b1;
            counter <= 10'b0000000000;
            count <= delay;
        end else if (counting) begin
            if (counter < 1000) begin
                counter <= counter + 1;
            end else begin
                counter <= 10'b0000000000;
                if (count > 0) begin
                    count <= count - 1;
                end else begin
                    counting <= 1'b0;
                    done <= 1'b1;
                end
            end
        end else if (done && ack) begin
            done <= 1'b0;
            pattern_match <= 1'b0;
            delay <= 4'b0000;
            counter <= 10'b0000000000;
            count <= 4'b0000;
            counting <= 1'b0;
        end
    end
end

endmodule