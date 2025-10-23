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
reg [2:0] state;
reg [3:0] pattern;
reg [3:0] bits_received;

parameter IDLE = 3'b000;
parameter PATTERN_DETECTION = 3'b001;
parameter COUNTING = 3'b010;
parameter WAIT_ACK = 3'b100;

always @(posedge clk or posedge reset) begin
    if (reset) begin
        state <= IDLE;
        delay_reg <= 4'd0;
        counter <= 20'd0;
        counting <= 1'b0;
        done <= 1'b0;
        count <= 4'd0;
        pattern <= 4'd0;
        bits_received <= 4'd0;
    end
    else begin
        case (state)
            IDLE: begin
                if (data) begin
                    pattern <= {pattern[2:0], 1'b1};
                end
                else begin
                    pattern <= {pattern[2:0], 1'b0};
                end
                if (pattern == 4'b1101) begin
                    state <= PATTERN_DETECTION;
                    pattern <= 4'd0;
                    bits_received <= 4'd0;
                end
            end
            PATTERN_DETECTION: begin
                delay_reg <= {delay_reg[2:0], data};
                bits_received <= bits_received + 1;
                if (bits_received == 4'd4) begin
                    state <= COUNTING;
                    counter <= (delay_reg + 1) * 1000 - 1;
                    counting <= 1'b1;
                end
            end
            COUNTING: begin
                if (counter > 20'd0) begin
                    counter <= counter - 1;
                    count <= delay_reg;
                    if (counter % 1000 == 999) begin
                        delay_reg <= delay_reg - 1;
                    end
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