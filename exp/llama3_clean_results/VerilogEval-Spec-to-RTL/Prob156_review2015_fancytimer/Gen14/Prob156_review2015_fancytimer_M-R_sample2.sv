module TopModule(
    input clk,
    input reset,
    input data,
    output reg [3:0] count,
    output reg counting,
    output reg done,
    input ack
);

reg [3:0] delay_reg;
reg [19:0] counter;
reg [3:0] remaining_time;
reg [3:0] pattern_reg;
reg [1:0] state;

parameter IDLE = 2'b00;
parameter SHIFT_DELAY = 2'b01;
parameter COUNTING = 2'b10;
parameter DONE_STATE = 2'b11;

always @(posedge clk or posedge reset) begin
    if (reset) begin
        state <= IDLE;
        delay_reg <= 4'd0;
        counter <= 20'd0;
        remaining_time <= 4'd0;
        pattern_reg <= 4'd0;
        counting <= 1'b0;
        done <= 1'b0;
    end
    else begin
        case (state)
            IDLE: begin
                if (pattern_reg == 4'b1101) begin
                    state <= SHIFT_DELAY;
                    pattern_reg <= 4'd0;
                end
                else begin
                    pattern_reg <= {data, pattern_reg[3:1]};
                end
            end
            SHIFT_DELAY: begin
                delay_reg <= {data, delay_reg[3:1]};
                if (delay_reg[0] == 1'b1) begin
                    state <= COUNTING;
                    counter <= (delay_reg + 1) * 1000 - 1;
                    remaining_time <= delay_reg;
                    counting <= 1'b1;
                end
            end
            COUNTING: begin
                if (counter > 20'd0) begin
                    counter <= counter - 1;
                    if (counter % 1000 == 999) begin
                        remaining_time <= remaining_time - 1;
                    end
                end
                else begin
                    state <= DONE_STATE;
                    counting <= 1'b0;
                    done <= 1'b1;
                end
            end
            DONE_STATE: begin
                if (ack) begin
                    state <= IDLE;
                    counter <= 20'd0;
                    delay_reg <= 4'd0;
                    remaining_time <= 4'd0;
                    done <= 1'b0;
                end
            end
        endcase
    end
end

assign count = (state == COUNTING) ? remaining_time : 4'bx;

endmodule