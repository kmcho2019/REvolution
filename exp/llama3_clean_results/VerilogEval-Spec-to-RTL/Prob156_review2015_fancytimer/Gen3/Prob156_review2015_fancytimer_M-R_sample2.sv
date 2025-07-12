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
reg [3:0] remaining;
reg [9:0] timer;
reg [3:0] pattern_reg;
reg [2:0] state;

parameter IDLE = 3'b000;
parameter PATTERN_DETECTION = 3'b001;
parameter DELAY_SHIFT = 3'b010;
parameter COUNTING = 3'b011;
parameter DONE = 3'b100;

always @(posedge clk or posedge reset) begin
    if (reset) begin
        state <= IDLE;
        delay <= 4'd0;
        remaining <= 4'd0;
        timer <= 10'd0;
        pattern_reg <= 4'd0;
        counting <= 1'b0;
        done <= 1'b0;
    end
    else begin
        case (state)
            IDLE: begin
                if (data) begin
                    pattern_reg <= {pattern_reg[2:0], 1'b1};
                    if (pattern_reg == 4'b1101) begin
                        state <= DELAY_SHIFT;
                        pattern_reg <= 4'd0;
                    end
                end
                else begin
                    pattern_reg <= {pattern_reg[2:0], 1'b0};
                end
            end
            DELAY_SHIFT: begin
                pattern_reg <= {pattern_reg[2:0], data};
                if (pattern_reg == 4'b1000) begin
                    delay <= pattern_reg;
                    state <= COUNTING;
                    remaining <= delay;
                    timer <= 10'd0;
                    counting <= 1'b1;
                end
            end
            COUNTING: begin
                if (timer == 10'd999) begin
                    timer <= 10'd0;
                    remaining <= remaining - 1;
                    if (remaining == 4'd0) begin
                        state <= DONE;
                        counting <= 1'b0;
                        done <= 1'b1;
                    end
                end
                else begin
                    timer <= timer + 10'd1;
                end
            end
            DONE: begin
                if (ack) begin
                    state <= IDLE;
                    done <= 1'b0;
                end
            end
        endcase
    end
end

assign count = remaining;

endmodule