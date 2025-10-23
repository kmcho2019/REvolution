module TopModule(
    input clk,
    input reset,
    input data,
    output reg [3:0] count,
    output reg counting,
    output reg done,
    input ack
);

reg [19:0] counter;
reg [3:0] delay_reg;
reg [3:0] remaining_time;
reg [1:0] state;

parameter IDLE = 2'b00;
parameter DETECT_PATTERN = 2'b01;
parameter COUNTING = 2'b10;
parameter WAIT_ACK = 2'b11;

always @(posedge clk or posedge reset) begin
    if (reset) begin
        state <= IDLE;
        counter <= 20'd0;
        delay_reg <= 4'd0;
        remaining_time <= 4'd0;
        counting <= 1'b0;
        done <= 1'b0;
        count <= 4'd0;
    end
    else begin
        case (state)
            IDLE: begin
                if (data == 1'b1) begin
                    state <= DETECT_PATTERN;
                    delay_reg <= 4'd0;
                end
            end
            DETECT_PATTERN: begin
                if (delay_reg == 4'b1101) begin
                    delay_reg <= {delay_reg[2:0], data};
                    if (delay_reg[3]) begin
                        state <= COUNTING;
                        if (delay_reg[3:0] > 4'd15) begin
                            remaining_time <= 4'd15;
                        end
                        else begin
                            remaining_time <= delay_reg[3:0];
                        end
                        counter <= (remaining_time + 1) * 1000 - 1;
                        counting <= 1'b1;
                    end
                end
                else begin
                    delay_reg <= {delay_reg[2:0], data};
                end
            end
            COUNTING: begin
                if (counter > 20'd0) begin
                    counter <= counter - 1;
                    if (counter % 1000 == 999) begin
                        remaining_time <= remaining_time - 1;
                    end
                    count <= remaining_time;
                end
                else begin
                    state <= WAIT_ACK;
                    done <= 1'b1;
                    counting <= 1'b0;
                end
            end
            WAIT_ACK: begin
                if (ack) begin
                    state <= IDLE;
                    done <= 1'b0;
                end
            end
        endcase
    end
end

endmodule