module TopModule(
    input  clk,
    input  reset,
    input  data,
    output [3:0] count,
    output counting,
    output done,
    input  ack
);

reg [3:0] delay;
reg [3:0] current_count;
reg [9:0] remaining_time;
reg [3:0] pattern;
reg [3:0] shift_counter;
reg searching, shifting, counting_state, waiting_ack;
reg [9:0] countdown;

always @(posedge clk) begin
    if (reset) begin
        searching <= 1'b1;
        shifting <= 1'b0;
        counting_state <= 1'b0;
        waiting_ack <= 1'b0;
        done <= 1'b0;
        counting <= 1'b0;
        pattern <= 4'b0000;
        shift_counter <= 4'b0000;
        current_count <= 4'b0000;
        remaining_time <= 10'b0000000000;
        countdown <= 10'b0000000000;
    end else if (searching) begin
        if (data == 1'b1) begin
            pattern <= {pattern[2:0], 1'b1};
            if (pattern == 4'b1101) begin
                shifting <= 1'b1;
                searching <= 1'b0;
            end
        end else begin
            pattern <= {pattern[2:0], 1'b0};
        end
    end else if (shifting) begin
        if (shift_counter == 4'b0000) begin
            delay <= {data, 3'b000};
        end else if (shift_counter == 4'b0001) begin
            delay <= {delay[2:0], data};
        end else if (shift_counter == 4'b0010) begin
            delay <= {delay[1:0], data, 1'b0};
        end else if (shift_counter == 4'b0011) begin
            delay <= {data, delay[2:0]};
        end
        shift_counter <= shift_counter + 1;
        if (shift_counter == 4'b1000) begin
            counting_state <= 1'b1;
            counting <= 1'b1;
            remaining_time <= ((delay + 1) * 1000) - 1;
            countdown <= ((delay + 1) * 1000) - 1;
            shifting <= 1'b0;
            shift_counter <= 4'b0000;
        end
    end else if (counting_state) begin
        remaining_time <= remaining_time - 1;
        countdown <= countdown - 1;
        if (remaining_time == 10'b0000000000) begin
            current_count <= current_count - 1;
            remaining_time <= 1000 - 1;
            countdown <= 1000 - 1;
            if (current_count == 4'b0000) begin
                waiting_ack <= 1'b1;
                counting_state <= 1'b0;
                counting <= 1'b0;
                done <= 1'b1;
            end
        end
    end else if (waiting_ack) begin
        if (ack == 1'b1) begin
            waiting_ack <= 1'b0;
            searching <= 1'b1;
            done <= 1'b0;
            current_count <= delay;
        end
    end
end

assign count = (counting_state) ? current_count : 4'bxxxx;

endmodule