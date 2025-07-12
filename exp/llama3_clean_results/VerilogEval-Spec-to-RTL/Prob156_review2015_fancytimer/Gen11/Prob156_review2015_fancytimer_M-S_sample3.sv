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
reg [1:0] delay_counter;

parameter IDLE = 2'b00;
parameter COUNTING = 2'b01;
parameter DONE_STATE = 2'b10;

reg [1:0] state;

always @(posedge clk or posedge reset) begin
    if (reset) begin
        state <= IDLE;
        delay_reg <= 4'd0;
        counter <= 20'd0;
        remaining_time <= 4'd0;
        delay_counter <= 2'd0;
        count <= 4'd0;
        counting <= 1'b0;
        done <= 1'b0;
    end
    else begin
        case (state)
            IDLE: begin
                if (data == 1'b1 && delay_counter == 2'd0) begin
                    delay_reg[3] <= 1'b1;
                    delay_counter <= delay_counter + 1;
                end
                else if (data == 1'b0 && delay_counter == 1) begin
                    delay_reg[2] <= 1'b0;
                    delay_counter <= delay_counter + 1;
                end
                else if (data == 1'b1 && delay_counter == 2) begin
                    delay_reg[1] <= 1'b1;
                    delay_counter <= delay_counter + 1;
                end
                else if (data == 1'b0 && delay_counter == 3) begin
                    delay_reg[0] <= 1'b0;
                    delay_counter <= 2'd0;
                    counter <= (delay_reg + 1) * 1000 - 1;
                    remaining_time <= delay_reg;
                    state <= COUNTING;
                    counting <= 1'b1;
                end
                else begin
                    delay_counter <= 2'd0;
                    delay_reg <= 4'd0;
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
                    delay_counter <= 2'd0;
                    count <= 4'd0;
                    done <= 1'b0;
                end
            end
        endcase
    end
end

always @(*) begin
    if (state == COUNTING) begin
        count = remaining_time;
    end
    else begin
        count = 4'bx;
    end
end

endmodule