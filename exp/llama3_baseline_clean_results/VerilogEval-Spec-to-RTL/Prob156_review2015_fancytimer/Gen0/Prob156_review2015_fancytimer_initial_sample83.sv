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
reg [3:0] current_count;
reg [9:0] count_counter;
reg [3:0] remaining_time;
reg start_sequence;
reg [3:0] sequence_counter;
reg counting_reg;
reg done_reg;
reg [1:0] state;
reg [1:0] next_state;

parameter IDLE = 2'b00;
parameter SHIFT = 2'b01;
parameter COUNT = 2'b10;
parameter DONE = 2'b11;

always @(posedge clk) begin
    if (reset) begin
        state <= IDLE;
        sequence_counter <= 4'b0000;
        start_sequence <= 1'b0;
        delay <= 4'b0000;
        count_counter <= 10'b0000000000;
        remaining_time <= 4'b0000;
        counting_reg <= 1'b0;
        done_reg <= 1'b0;
    end else begin
        case (state)
            IDLE: begin
                if (data == 1'b1 && sequence_counter == 4'b0000) begin
                    sequence_counter <= 4'b0001;
                end else if (data == 1'b0 && sequence_counter == 4'b0001) begin
                    sequence_counter <= 4'b0010;
                end else if (data == 1'b1 && sequence_counter == 4'b0010) begin
                    sequence_counter <= 4'b0011;
                end else if (data == 1'b0 && sequence_counter == 4'b0011) begin
                    sequence_counter <= 4'b0000;
                    start_sequence <= 1'b1;
                end else begin
                    sequence_counter <= 4'b0000;
                    start_sequence <= 1'b0;
                end
                if (start_sequence == 1'b1) begin
                    state <= SHIFT;
                end
            end
            SHIFT: begin
                delay[3] <= data;
                state <= SHIFT;
                if (count_counter == 10'b0000000000) begin
                    count_counter <= 10'b0000000001;
                end else if (count_counter == 10'b0000000001) begin
                    delay[2] <= data;
                    count_counter <= 10'b0000000010;
                end else if (count_counter == 10'b0000000010) begin
                    delay[1] <= data;
                    count_counter <= 10'b0000000011;
                end else if (count_counter == 10'b0000000011) begin
                    delay[0] <= data;
                    count_counter <= 10'b0000000000;
                    state <= COUNT;
                    remaining_time <= delay + 4'b0001;
                    counting_reg <= 1'b1;
                end
            end
            COUNT: begin
                if (count_counter == 10'b0000000000) begin
                    if (remaining_time > 4'b0000) begin
                        remaining_time <= remaining_time - 4'b0001;
                    end
                end
                if (count_counter == 10'b1111101000) begin
                    count_counter <= 10'b0000000000;
                end else begin
                    count_counter <= count_counter + 1'b1;
                end
                if (remaining_time == 4'b0000) begin
                    counting_reg <= 1'b0;
                    state <= DONE;
                end
            end
            DONE: begin
                done_reg <= 1'b1;
                if (ack == 1'b1) begin
                    state <= IDLE;
                    done_reg <= 1'b0;
                end
            end
        endcase
    end
end

assign count = (state == COUNT) ? remaining_time : 4'bxxxx;
assign counting = counting_reg;
assign done = done_reg;

endmodule