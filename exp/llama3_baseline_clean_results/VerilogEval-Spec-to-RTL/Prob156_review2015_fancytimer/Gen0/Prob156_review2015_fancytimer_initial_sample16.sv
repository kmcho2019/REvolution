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
reg [15:0] counter;
reg [3:0] count_reg;
reg counting_reg;
reg done_reg;
reg [3:0] pattern;
reg [3:0] pattern_reg;

always @ (posedge clk or posedge reset) begin
    if (reset) begin
        pattern_reg <= 0;
        delay <= 0;
        counter <= 0;
        count_reg <= 0;
        counting_reg <= 0;
        done_reg <= 0;
    end else begin
        case (pattern_reg)
            4'b0000: begin // idle
                if (data == 1) begin
                    pattern_reg <= {pattern_reg[2:0], 1'b1};
                end else if (data == 0) begin
                    pattern_reg <= {pattern_reg[2:0], 1'b0};
                end else begin
                    pattern_reg <= pattern_reg;
                end
                if (pattern_reg == 4'b1101) begin
                    pattern_reg <= 4'b1000; // delay_shift
                end
            end
            4'b1000: begin // delay_shift
                delay[3] <= data;
                pattern_reg <= {pattern_reg[2:0], 1'b0};
                if (pattern_reg == 4'b0000) begin
                    pattern_reg <= 4'b1001; // counting
                    counter <= {12'b0, delay} * 1000 + 1000;
                    count_reg <= delay;
                    counting_reg <= 1;
                end
            end
            4'b1001: begin // counting
                if (counter > 1000) begin
                    counter <= counter - 1;
                    if (counter[0] == 1'b0) begin
                        count_reg <= count_reg - 1;
                    end
                end else begin
                    counting_reg <= 0;
                    done_reg <= 1;
                    pattern_reg <= 4'b1010; // done
                end
            end
            4'b1010: begin // done
                if (ack == 1) begin
                    done_reg <= 0;
                    pattern_reg <= 4'b0000; // idle
                end
            end
        endcase
    end
end

assign count = count_reg;
assign counting = counting_reg;
assign done = done_reg;

endmodule