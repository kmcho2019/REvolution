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
reg [3:0] shift_count;
reg [3:0] remaining_time;

assign counting = (state == 2'b10);
assign done = (state == 2'b11);

always @(posedge clk or posedge reset) begin
    if (reset) begin
        state <= 2'b00;
        count <= 4'd0;
        pattern <= 4'd0;
        delay <= 4'd0;
        counter <= 20'd0;
        shift_count <= 4'd0;
        remaining_time <= 4'd0;
    end
    else begin
        case (state)
            2'b00: begin // IDLE
                pattern <= {data, pattern[3:1]};
                if (pattern == 4'b1101) begin
                    state <= 2'b01;
                    shift_count <= 4'd0;
                end
            end
            2'b01: begin // SHIFT_DELAY
                delay <= {data, delay[3:1]};
                shift_count <= shift_count + 1;
                if (shift_count == 4'd4) begin
                    state <= 2'b10;
                    counter <= 20'd0;
                    remaining_time <= delay;
                end
            end
            2'b10: begin // COUNTDOWN
                counter <= counter + 1;
                if (counter == 20'd1000) begin
                    counter <= 20'd0;
                    remaining_time <= remaining_time - 1;
                end
                if (remaining_time == 4'd0) begin
                    state <= 2'b11;
                end
                count <= remaining_time;
            end
            2'b11: begin // WAIT_ACK
                if (ack) begin
                    state <= 2'b00;
                end
            end
        endcase
    end
end

endmodule