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
reg [3:0] count_register;
reg [3:0] pattern_register;
reg [2:0] shift_counter;
reg counting_reg;
reg done_reg;

always @(posedge clk) begin
    if (reset) begin
        pattern_register <= 0;
        shift_counter <= 0;
        delay <= 0;
        remaining_time <= 0;
        count_register <= 0;
        counting_reg <= 0;
        done_reg <= 0;
    end else begin
        // IDLE state
        if (pattern_register == 0) begin
            pattern_register <= {pattern_register[2:0], data};
            if (pattern_register == 4'b1101) begin
                pattern_register <= 0;
                shift_counter <= 4;
            end
        // SHIFT state
        end else if (shift_counter != 0) begin
            delay <= {delay[2:0], data};
            shift_counter <= shift_counter - 1;
            if (shift_counter == 0) begin
                remaining_time <= delay + 1;
                counting_reg <= 1;
            end
        // COUNT state
        end else if (counting_reg) begin
            count_register <= count_register + 1;
            if (count_register == 999) begin
                remaining_time <= remaining_time - 1;
                count_register <= 0;
            end
            if (remaining_time == 0) begin
                counting_reg <= 0;
                done_reg <= 1;
            end
        // DONE state
        end else if (done_reg && ack) begin
            done_reg <= 0;
            pattern_register <= 0;
        end
    end
end

assign count = counting_reg ? remaining_time : 4'bxxxx;
assign counting = counting_reg;
assign done = done_reg;

endmodule