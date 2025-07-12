module TopModule(
    input clk,
    input reset,
    input data,
    output [3:0] count,
    output counting,
    output done,
    input ack
);

reg [3:0] delay;
reg [3:0] remaining;
reg [3:0] counter;
reg [3:0] pattern;
reg counting_reg;
reg done_reg;

always @(posedge clk) begin
    if (reset) begin
        pattern <= 0;
        counting_reg <= 0;
        done_reg <= 0;
        counter <= 0;
        remaining <= 0;
    end else begin
        if (done_reg && ack) begin
            pattern <= 0;
            counting_reg <= 0;
            done_reg <= 0;
            counter <= 0;
            remaining <= 0;
        end else if (~done_reg) begin
            if (pattern == 4'd8) begin // 1101
                pattern <= 0;
                counting_reg <= 1;
                delay <= {data, delay[2:0]};
            end else if (counting_reg && counter == 1000) begin
                remaining <= remaining - 1;
                counter <= 0;
                if (remaining == 0) begin
                    counting_reg <= 0;
                    done_reg <= 1;
                end
            end else if (counting_reg) begin
                counter <= counter + 1;
            end else if (pattern != 4'd8) begin
                pattern <= {pattern[2:0], data};
            end
        end
    end
end

assign count = (counting_reg) ? remaining : 4'd0;
assign counting = counting_reg;

always @(posedge clk) begin
    if (reset) begin
        done_reg <= 0;
    end else if (~done_reg && ~counting_reg && pattern == 0) begin
        done_reg <= 0;
    end else if (~done_reg && counting_reg && remaining == 0) begin
        done_reg <= 1;
    end else if (done_reg && ack) begin
        done_reg <= 0;
    end
end

assign done = done_reg;

initial begin
    remaining = 1;
    pattern = 0;
    counting_reg = 0;
    done_reg = 0;
    counter = 0;
end

endmodule