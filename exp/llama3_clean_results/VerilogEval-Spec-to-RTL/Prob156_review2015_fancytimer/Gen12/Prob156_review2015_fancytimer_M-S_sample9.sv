module TopModule(
    input clk,
    input reset,
    input data,
    output reg [3:0] count,
    output reg counting,
    output reg done,
    input ack
);

reg [3:0] delay;
reg [19:0] counter;
reg [3:0] sequence;
reg [1:0] state;

parameter IDLE = 2'b00;
parameter COUNTING = 2'b01;
parameter DONE = 2'b10;

always @(posedge clk or posedge reset) begin
    if (reset) begin
        sequence <= 4'd0;
        state <= IDLE;
        counter <= 20'd0;
        count <= 4'd0;
        delay <= 4'd0;
        counting <= 1'b0;
        done <= 1'b0;
    end
    else begin
        case (state)
            IDLE: begin
                sequence <= {data, sequence[3:1]};
                if (sequence == 4'b1101) begin
                    state <= IDLE;
                end
                else if (sequence == 4'b1101 && data == 1'b1) begin
                    state <= IDLE;
                    delay[3] <= data;
                end
                else if (sequence == 4'b1101 && data == 1'b0) begin
                    state <= IDLE;
                    delay[2] <= data;
                end
                else if (sequence == 4'b1101 && data == 1'b1) begin
                    state <= IDLE;
                    delay[1] <= data;
                end
                else if (sequence == 4'b1101 && data == 1'b0) begin
                    state <= COUNTING;
                    counter <= (delay + 1) * 1000 - 1;
                    count <= delay;
                end
            end
            COUNTING: begin
                if (counter > 20'd0) begin
                    counter <= counter - 1;
                    if (counter % 1000 == 999) begin
                        count <= count - 1;
                    end
                    counting <= 1'b1;
                end
                else begin
                    state <= DONE;
                    counting <= 1'b0;
                end
            end
            DONE: begin
                done <= 1'b1;
                if (ack) begin
                    state <= IDLE;
                    done <= 1'b0;
                end
            end
        endcase
    end
end

endmodule