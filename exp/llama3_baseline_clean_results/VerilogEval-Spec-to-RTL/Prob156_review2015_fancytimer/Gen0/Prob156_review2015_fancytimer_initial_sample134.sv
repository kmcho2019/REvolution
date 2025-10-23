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
reg [3:0] remaining_time;
reg [3:0] count_reg;
reg [3:0] shift_reg;
reg searching;
reg shifting;
reg counting_reg;
reg done_reg;
reg [3:0] bit_counter;
reg [3:0] count_counter;

always @(posedge clk) begin
    if (reset) begin
        searching <= 1;
        shifting <= 0;
        counting_reg <= 0;
        done_reg <= 0;
        bit_counter <= 0;
        count_counter <= 0;
        shift_reg <= 0;
        count_reg <= 0;
        remaining_time <= 0;
    end else begin
        if (searching) begin
            if (data) begin
                if (bit_counter == 0) begin
                    shift_reg <= {shift_reg[2:0], 1'b1};
                end else if (bit_counter == 1) begin
                    shift_reg <= {shift_reg[2:0], 1'b1};
                end else if (bit_counter == 2) begin
                    shift_reg <= {shift_reg[2:0], 1'b0};
                end else if (bit_counter == 3) begin
                    shift_reg <= {shift_reg[2:0], 1'b1};
                    searching <= 0;
                    shifting <= 1;
                    bit_counter <= 0;
                end else begin
                    searching <= 1;
                    bit_counter <= 0;
                end
                bit_counter <= bit_counter + 1;
            end else begin
                if (bit_counter == 0) begin
                    shift_reg <= {shift_reg[2:0], 1'b0};
                end else if (bit_counter == 1) begin
                    shift_reg <= {shift_reg[2:0], 1'b1};
                end else if (bit_counter == 2) begin
                    shift_reg <= {shift_reg[2:0], 1'b1};
                end else if (bit_counter == 3) begin
                    shift_reg <= {shift_reg[2:0], 1'b1};
                    searching <= 0;
                    shifting <= 1;
                    bit_counter <= 0;
                end else begin
                    searching <= 1;
                    bit_counter <= 0;
                end
                bit_counter <= bit_counter + 1;
            end
        end else if (shifting) begin
            delay[3] <= data;
            delay[2] <= delay[3];
            delay[1] <= delay[2];
            delay[0] <= delay[1];
            bit_counter <= bit_counter + 1;
            if (bit_counter == 3) begin
                shifting <= 0;
                counting_reg <= 1;
                remaining_time <= (delay + 1) * 1000;
            end
        end else if (counting_reg) begin
            remaining_time <= remaining_time - 1;
            count_reg <= delay;
            if (remaining_time == 0) begin
                delay <= delay - 1;
                remaining_time <= 1000;
                count_reg <= delay;
            end
            if (delay == 0 && remaining_time == 0) begin
                counting_reg <= 0;
                done_reg <= 1;
            end
        end else if (done_reg) begin
            if (ack) begin
                done_reg <= 0;
                searching <= 1;
                shift_reg <= 0;
                count_reg <= 0;
                remaining_time <= 0;
                delay <= 0;
            end
        end
    end
end

assign count = (counting_reg) ? count_reg : 4'bxxxx;
assign counting = counting_reg;
assign done = done_reg;

endmodule