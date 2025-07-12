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
reg [3:0] pattern;
reg [19:0] counter;
reg [1:0] state;
reg [1:0] next_state;
reg [3:0] shift_count;

always @(*) begin
    case (state)
        2'b00: begin // IDLE
            pattern = {pattern[2:0], data};
            if (pattern == 4'b1101) begin
                next_state = 2'b01;
                shift_count = 4'd0;
            end
            else begin
                next_state = 2'b00;
            end
        end
        2'b01: begin // SHIFT_DELAY
            delay = {delay[2:0], data};
            shift_count = shift_count + 1;
            if (shift_count == 4'd4) begin
                next_state = 2'b10;
                counter = 20'd0;
                counting = 1'b1;
            end
            else begin
                next_state = 2'b01;
            end
        end
        2'b10: begin // COUNTDOWN
            counter = counter + 1;
            if (counter == 20'd1000) begin
                counter = 20'd0;
                delay = delay - 1;
            end
            if (delay == 4'd0) begin
                next_state = 2'b11;
                counting = 1'b0;
                done = 1'b1;
            end
            else begin
                next_state = 2'b10;
            end
        end
        2'b11: begin // WAIT_ACK
            if (ack) begin
                next_state = 2'b00;
                done = 1'b0;
            end
            else begin
                next_state = 2'b11;
            end
        end
    endcase
end

always @(posedge clk or posedge reset) begin
    if (reset) begin
        state <= 2'b00;
        count <= 4'd0;
        pattern <= 4'd0;
        delay <= 4'd0;
        counter <= 20'd0;
        counting <= 1'b0;
        done <= 1'b0;
    end
    else begin
        state <= next_state;
        if (state == 2'b10) begin
            if (counter < 20'd500) begin
                count <= delay;
            end
            else begin
                count <= delay - 1;
            end
        end
        else begin
            count <= 4'd0;
        end
    end
end

endmodule