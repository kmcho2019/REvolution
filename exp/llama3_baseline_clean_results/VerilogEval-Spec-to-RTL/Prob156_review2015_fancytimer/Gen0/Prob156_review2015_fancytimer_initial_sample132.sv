module TopModule (
    input  clk,
    input  reset,
    input  data,
    output [3:0] count,
    output counting,
    output done,
    input  ack
);

reg [3:0] delay;
reg [3:0] counter;
reg [9:0] cycle_counter;
reg [3:0] remaining_time;
reg [3:0] shift_register;
reg start;
reg counting_reg;
reg done_reg;

always @ (posedge clk) begin
    if (reset) begin
        start <= 0;
        counting_reg <= 0;
        done_reg <= 0;
        counter <= 0;
        cycle_counter <= 0;
        remaining_time <= 0;
        shift_register <= 0;
    end else begin
        // IDLE state
        if (~start) begin
            if (shift_register == 4'b1101) begin
                start <= 1;
            end else begin
                shift_register <= {shift_register[2:0], data};
            end
        // SHIFT state
        end else if (counter < 4) begin
            delay[3-counter] <= data;
            counter <= counter + 1;
            if (counter == 4) begin
                counting_reg <= 1;
                remaining_time <= delay + 1;
                cycle_counter <= 0;
            end
        // COUNTING state
        end else if (counting_reg) begin
            cycle_counter <= cycle_counter + 1;
            if (cycle_counter == 1000) begin
                remaining_time <= remaining_time - 1;
                cycle_counter <= 0;
                if (remaining_time == 0) begin
                    counting_reg <= 0;
                    done_reg <= 1;
                end
            end
        // DONE state
        end else if (done_reg) begin
            if (ack) begin
                start <= 0;
                done_reg <= 0;
                counter <= 0;
                cycle_counter <= 0;
                remaining_time <= 0;
                shift_register <= 0;
            end
        end
    end
end

assign count = counting_reg ? {4{remaining_time[3]} == 1 ? 4'b1111 : remaining_time} : 4'bxxxx;
assign counting = counting_reg;
assign done = done_reg;

endmodule