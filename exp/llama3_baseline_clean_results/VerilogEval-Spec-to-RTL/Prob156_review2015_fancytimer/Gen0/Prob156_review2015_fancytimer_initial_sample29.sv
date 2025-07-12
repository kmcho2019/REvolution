module TopModule(
    input clk,
    input reset,
    input data,
    output [3:0] count,
    output counting,
    output done,
    input ack
);

reg [3:0] state;
reg [3:0] delay;
reg [3:0] remaining_time;
reg [11:0] counter;
reg [3:0] data_shift;
reg pattern_found;
reg [3:0] count_out;

// Define the states
parameter IDLE = 4'b0000;
parameter GET_DELAY = 4'b0001;
parameter COUNTING = 4'b0010;
parameter DONE = 4'b0011;

always @(posedge clk) begin
    if (reset) begin
        state <= IDLE;
        pattern_found <= 0;
        data_shift <= 0;
        delay <= 0;
        remaining_time <= 0;
        counter <= 0;
        count_out <= 0;
        counting <= 0;
        done <= 0;
    end else begin
        case (state)
            IDLE: begin
                if (data_shift == 4'b1101) begin
                    state <= GET_DELAY;
                    pattern_found <= 1;
                    data_shift <= 0;
                end else if (data == 1'b1) begin
                    data_shift <= {data_shift[2:0], 1'b1};
                end else if (data == 1'b0) begin
                    data_shift <= {data_shift[2:0], 1'b0};
                end
            end
            GET_DELAY: begin
                data_shift <= {data, data_shift[3:1]};
                if (data_shift[3:0] == 4'b1000) begin
                    state <= COUNTING;
                    delay <= data_shift[3:0];
                    remaining_time <= delay;
                    counter <= 0;
                    count_out <= delay;
                    counting <= 1;
                end else if (data_shift[3:0] != 4'b1000) begin
                    // Do nothing
                end
            end
            COUNTING: begin
                counter <= counter + 1;
                if (counter == 1000) begin
                    remaining_time <= remaining_time - 1;
                    counter <= 0;
                    count_out <= remaining_time;
                end
                if (remaining_time == 0) begin
                    state <= DONE;
                    counting <= 0;
                    done <= 1;
                end
            end
            DONE: begin
                if (ack == 1'b1) begin
                    state <= IDLE;
                    done <= 0;
                    pattern_found <= 0;
                    data_shift <= 0;
                    delay <= 0;
                    remaining_time <= 0;
                    counter <= 0;
                    count_out <= 0;
                end
            end
        endcase
    end
end

assign count = (state == COUNTING) ? count_out : 4'bxxxx;

endmodule