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
reg [1:0] current_state;
reg [1:0] next_state;

parameter IDLE = 2'b00;
parameter SHIFT_DELAY = 2'b01;
parameter COUNTING = 2'b10;
parameter DONE_STATE = 2'b11;

always @(posedge clk or posedge reset) begin
    if (reset) begin
        current_state <= IDLE;
        delay_reg <= 4'd0;
        counter <= 20'd0;
        remaining_time <= 4'd0;
        pattern_reg <= 4'd0;
        counting <= 1'b0;
        done <= 1'b0;
    end
    else begin
        case (current_state)
            IDLE: begin
                if (pattern_reg == 4'b1101) begin
                    next_state <= SHIFT_DELAY;
                    pattern_reg <= 4'd0;
                end
                else begin
                    pattern_reg <= {data, pattern_reg[3:1]};
                    next_state <= IDLE;
                end
            end
            SHIFT_DELAY: begin
                delay_reg <= {data, delay_reg[3:1]};
                if (delay_reg[0] == 1'b0) begin // assuming MSB is 1
                    next_state <= SHIFT_DELAY;
                end
                else begin
                    next_state <= COUNTING;
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
                    next_state <= COUNTING;
                end
                else begin
                    next_state <= DONE_STATE;
                    counting <= 1'b0;
                    done <= 1'b1;
                end
            end
            DONE_STATE: begin
                if (ack) begin
                    next_state <= IDLE;
                    counter <= 20'd0;
                    delay_reg <= 4'd0;
                    remaining_time <= 4'd0;
                    done <= 1'b0;
                end
                else begin
                    next_state <= DONE_STATE;
                end
            end
        endcase
        current_state <= next_state;
    end
end

assign count = (current_state == COUNTING)? remaining_time : 4'd0;

endmodule