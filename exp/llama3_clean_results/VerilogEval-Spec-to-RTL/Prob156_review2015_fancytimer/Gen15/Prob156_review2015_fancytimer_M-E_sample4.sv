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
reg [2:0] state;

parameter IDLE = 3'b001;
parameter DETECT_PATTERN = 3'b010;
parameter SHIFT_DELAY = 3'b011;
parameter COUNTDOWN = 3'b100;
parameter WAIT_ACK = 3'b101;

always @(posedge clk or posedge reset) begin
    if (reset) begin
        state <= IDLE;
        count <= 4'd0;
        pattern <= 4'd0;
        delay <= 4'd0;
        counter <= 20'd0;
        counting <= 1'b0;
        done <= 1'b0;
    end
    else begin
        case (state)
            IDLE: begin
                if (data == 1'b1) begin
                    pattern <= {pattern[2:0], 1'b1};
                end
                else begin
                    pattern <= {pattern[2:0], 1'b0};
                end
                if (pattern == 4'b1101) begin
                    state <= DETECT_PATTERN;
                    pattern <= 4'd0;
                end
            end
            DETECT_PATTERN: begin
                if (data == 1'b1) begin
                    pattern <= {pattern[2:0], 1'b1};
                end
                else begin
                    pattern <= {pattern[2:0], 1'b0};
                end
                if (pattern == 4'b1) begin
                    state <= SHIFT_DELAY;
                    delay <= 4'd0;
                end
            end
            SHIFT_DELAY: begin
                delay <= {delay[2:0], data};
                if (delay[0]) begin
                    state <= COUNTDOWN;
                    counter <= 20'd0;
                    counting <= 1'b1;
                end
            end
            COUNTDOWN: begin
                counter <= counter + 1;
                count <= delay;
                if (counter == 20'd999) begin
                    counter <= 20'd0;
                    delay <= delay - 1;
                end
                if (delay == 4'd0) begin
                    state <= WAIT_ACK;
                    counting <= 1'b0;
                    done <= 1'b1;
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