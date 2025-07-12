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
reg [3:0] count_reg;
reg [9:0] counter;
reg [3:0] pattern;
reg [2:0] state;
reg counting_reg;
reg done_reg;

always @(posedge clk) begin
    if (reset) begin
        state <= 0;
        pattern <= 0;
        counter <= 0;
        count_reg <= 0;
        delay <= 0;
        counting_reg <= 0;
        done_reg <= 0;
    end
    else begin
        case (state)
            0: begin // Idle
                pattern <= {data, pattern[2:0]};
                if (pattern == 4'b1101) begin
                    state <= 1;
                    pattern <= 0;
                end
            end
            1: begin // Shift
                delay <= {data, delay[2:0]};
                pattern <= pattern + 1;
                if (pattern == 4) begin
                    state <= 2;
                    pattern <= 0;
                    counter <= (delay + 1) * 10'd1000 - 10'd1000;
                    count_reg <= delay;
                    counting_reg <= 1;
                end
            end
            2: begin // Counting
                if (counter == 0) begin
                    state <= 3;
                    counting_reg <= 0;
                end
                else begin
                    counter <= counter - 1;
                    if (counter % 1000 == 0) begin
                        count_reg <= count_reg - 1;
                    end
                end
            end
            3: begin // Done
                done_reg <= 1;
                if (ack) begin
                    state <= 0;
                    done_reg <= 0;
                end
            end
        endcase
    end
end

assign count = (state == 2) ? count_reg : 4'bxxxx;
assign counting = counting_reg;
assign done = done_reg;

endmodule