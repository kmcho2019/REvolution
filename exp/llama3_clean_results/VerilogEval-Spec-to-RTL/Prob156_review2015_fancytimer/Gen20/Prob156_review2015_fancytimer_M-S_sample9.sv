module TopModule(
    input clk,
    input reset,
    input data,
    output reg [3:0] count,
    output reg counting,
    output reg done,
    input ack
);

reg [3:0] pattern_shift_reg;
reg [3:0] delay;
reg [19:0] counter;
reg [3:0] remaining_time;
reg state;

always @(posedge clk or posedge reset) begin
    if (reset) begin
        pattern_shift_reg <= 0;
        delay <= 0;
        counter <= 0;
        remaining_time <= 0;
        counting <= 0;
        done <= 0;
        state <= 0;
    end else begin
        case (state)
            0: begin // searching for pattern
                pattern_shift_reg <= {pattern_shift_reg[2:0], data};
                if (pattern_shift_reg == 4'b1101) begin
                    state <= 1;
                end
            end
            1: begin // shifting in delay bits
                delay <= {data, delay[3:1]};
                if (delay[0] == 1'b1) begin // most significant bit is 1, so we've shifted in all 4 bits
                    state <= 2;
                    counter <= (delay + 1) * 1000 - 1;
                    remaining_time <= delay;
                    counting <= 1;
                end
            end
            2: begin // counting down delay
                if (counter > 0) begin
                    counter <= counter - 1;
                    if (counter % 1000 == 0) begin
                        remaining_time <= remaining_time - 1;
                    end
                end else begin
                    counting <= 0;
                    state <= 3;
                end
            end
            3: begin // waiting for ack
                if (ack == 1'b1) begin
                    done <= 0;
                    state <= 0;
                end else begin
                    done <= 1;
                end
            end
        endcase
    end
end

assign count = remaining_time;

endmodule