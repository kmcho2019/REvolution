module TopModule (
    input clk,
    input reset,
    input data,
    output [3:0] count,
    output counting,
    output done,
    input ack
);

reg [3:0] delay;
reg [3:0] current_count;
reg [9:0] counter;
reg [3:0] remaining_time;
reg counting_reg;
reg done_reg;
reg [3:0] pattern;

always @(posedge clk) begin
    if (reset) begin
        delay <= 4'b0;
        current_count <= 4'b0;
        counter <= 10'b0;
        remaining_time <= 4'b0;
        counting_reg <= 1'b0;
        done_reg <= 1'b0;
        pattern <= 4'b0;
    end else begin
        case (pattern)
            4'b0: begin
                if (data) begin
                    pattern <= {1'b1, pattern[2:0]};
                end else begin
                    pattern <= {1'b0, pattern[2:0]};
                end
            end
            4'b1001: begin
                if (data) begin
                    pattern <= {1'b1, pattern[2:0]};
                end else begin
                    delay <= {data, delay[2:0]};
                    pattern <= 4'b0;
                    remaining_time <= delay + 1'b1;
                    counting_reg <= 1'b1;
                end
            end
            default: begin
                if (data) begin
                    pattern <= {1'b1, pattern[2:0]};
                end else begin
                    pattern <= {1'b0, pattern[2:0]};
                end
            end
        endcase

        if (counting_reg) begin
            if (counter == 10'd999) begin
                counter <= 10'b0;
                remaining_time <= remaining_time - 1'b1;
                if (remaining_time == 4'b0) begin
                    counting_reg <= 1'b0;
                    done_reg <= 1'b1;
                end
            end else begin
                counter <= counter + 1'b1;
            end
        end

        if (done_reg && ack) begin
            done_reg <= 1'b0;
            pattern <= 4'b0;
        end
    end
end

assign counting = counting_reg;
assign done = done_reg;
assign count = (counting_reg) ? remaining_time : 4'bxxxx;

endmodule