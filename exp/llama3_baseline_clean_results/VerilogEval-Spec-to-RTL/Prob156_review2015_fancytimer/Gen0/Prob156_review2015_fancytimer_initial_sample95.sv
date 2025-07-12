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
reg [11:0] counter;
reg [3:0] count_out;
reg [3:0] pattern;
reg counting_reg;
reg done_reg;

always @(posedge clk) begin
    if (reset) begin
        pattern <= 0;
        counting_reg <= 0;
        done_reg <= 0;
        counter <= 0;
        count_out <= 0;
    end else begin
        case (pattern)
            0: begin
                if (data) begin
                    pattern <= pattern << 1 | 1;
                end else begin
                    pattern <= pattern << 1;
                end
                if (pattern == 14) begin // 1101 in binary is 13, but we add one to it because we left shift it before checking
                    pattern <= 0;
                    delay <= 0;
                    counting_reg <= 0;
                    done_reg <= 0;
                    counter <= 0;
                    count_out <= 0;
                end
            end
            1: begin
                delay[3] <= data;
                pattern <= pattern << 1;
                if (pattern == 16) begin
                    pattern <= 0;
                    counting_reg <= 1;
                end
            end
            2: begin
                delay[2] <= data;
                pattern <= pattern << 1;
                if (pattern == 16) begin
                    pattern <= 0;
                    counting_reg <= 1;
                end
            end
            3: begin
                delay[1] <= data;
                pattern <= pattern << 1;
                if (pattern == 16) begin
                    pattern <= 0;
                    counting_reg <= 1;
                end
            end
            4: begin
                delay[0] <= data;
                pattern <= 0;
                counting_reg <= 1;
            end
            default: begin
                if (counting_reg) begin
                    if (counter < ((delay + 1) * 1000)) begin
                        counter <= counter + 1;
                        if (counter % 1000 == 0) begin
                            count_out <= count_out - 1;
                        end
                    end else begin
                        counting_reg <= 0;
                        done_reg <= 1;
                    end
                end
                if (done_reg && ack) begin
                    done_reg <= 0;
                    pattern <= 0;
                    counting_reg <= 0;
                    counter <= 0;
                    count_out <= 0;
                end
            end
        endcase
    end
end

assign count = counting_reg ? count_out : 4'bxxxx;
assign counting = counting_reg;
assign done = done_reg;

endmodule