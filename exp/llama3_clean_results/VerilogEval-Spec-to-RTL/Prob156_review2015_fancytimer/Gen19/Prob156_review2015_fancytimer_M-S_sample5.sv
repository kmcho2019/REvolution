module TopModule(
    input clk,
    input reset,
    input data,
    output reg [3:0] count,
    output reg counting,
    output reg done,
    input ack
);

reg [3:0] shift_reg;
reg [3:0] delay;
reg [19:0] counter;
reg [3:0] remaining_time;
reg start_pattern;
reg counting_flag;

always @(posedge clk or posedge reset) begin
    if (reset) begin
        shift_reg <= 0;
        delay <= 0;
        counter <= 0;
        remaining_time <= 0;
        start_pattern <= 0;
        counting_flag <= 0;
        count <= 0;
        counting <= 0;
        done <= 0;
    end else begin
        if (~start_pattern) begin
            shift_reg <= {shift_reg[2:0], data};
            if (shift_reg == 4'b1101) begin
                start_pattern <= 1;
            end
        end else if (shift_reg == 4'b1101 && ~counting_flag) begin
            delay <= {data, delay[3:1]};
            shift_reg <= {shift_reg[2:0], 1'b0}; // Prepare for next input
            if (delay[0] == 1'b1) begin // Assume MSB is 1
                start_pattern <= 0;
                counting_flag <= 1;
                counter <= (delay + 1) * 1000 - 1;
                remaining_time <= delay;
                counting <= 1;
            end
        end else if (counting_flag) begin
            if (counter > 0) begin
                counter <= counter - 1;
                if (counter % 1000 == 0) begin
                    remaining_time <= remaining_time - 1;
                end
            end else begin
                counting_flag <= 0;
                counting <= 0;
                done <= 1;
            end
        end
        if (done && ack) begin
            done <= 0;
        end
        count <= remaining_time;
    end
end

endmodule