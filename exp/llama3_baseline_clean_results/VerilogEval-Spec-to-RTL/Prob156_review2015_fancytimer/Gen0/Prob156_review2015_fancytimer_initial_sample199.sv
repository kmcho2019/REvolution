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
reg [9:0] clock_counter;
reg [3:0] pattern;
reg counting_reg;
reg done_reg;

reg [1:0] state;
localparam IDLE = 2'b00;
localparam SHIFT_DELAY = 2'b01;
localparam COUNTING = 2'b10;
localparam DONE = 2'b11;

always @(posedge clk) begin
    if (reset) begin
        state <= IDLE;
        delay <= 4'b0;
        remaining_time <= 4'b0;
        clock_counter <= 10'b0;
        pattern <= 4'b0;
        counting_reg <= 1'b0;
        done_reg <= 1'b0;
    end else begin
        case (state)
            IDLE: begin
                pattern <= {pattern[2:0], data};
                if (pattern == 4'b1101) begin
                    state <= SHIFT_DELAY;
                end
            end
            SHIFT_DELAY: begin
                delay <= {delay[2:0], data};
                if (delay[0] != 1'bx) begin
                    state <= COUNTING;
                    counting_reg <= 1'b1;
                    remaining_time <= delay + 1'b1;
                    clock_counter <= 10'b0;
                end
            end
            COUNTING: begin
                if (clock_counter == 10'b0) begin
                    remaining_time <= remaining_time - 1'b1;
                end
                clock_counter <= clock_counter + 1'b1;
                if (clock_counter == 10'b1000) begin
                    clock_counter <= 10'b0;
                    if (remaining_time == 4'b0) begin
                        state <= DONE;
                        counting_reg <= 1'b0;
                    end
                end
            end
            DONE: begin
                done_reg <= 1'b1;
                if (ack) begin
                    state <= IDLE;
                    done_reg <= 1'b0;
                end
            end
        endcase
    end
end

assign count = (state == COUNTING) ? delay - remaining_time + 1'b1 : 4'bx;
assign counting = counting_reg;
assign done = done_reg;

endmodule