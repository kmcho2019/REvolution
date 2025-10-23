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
reg [3:0] pattern;
reg [1:0] state;
reg [2:0] bit_counter;

parameter IDLE = 2'b00;
parameter DELAY_DETECTION = 2'b01;
parameter COUNTING = 2'b10;
parameter DONE = 2'b11;

always @(posedge clk or posedge reset) begin
    if (reset) begin
        state <= IDLE;
        delay_reg <= 4'd0;
        counter <= 20'd0;
        pattern <= 4'd0;
        bit_counter <= 3'd0;
        count <= 4'd0;
        done <= 1'b0;
        counting <= 1'b0;
    end
    else begin
        case (state)
            IDLE: begin
                pattern <= {pattern[2:0], data};
                if (pattern == 4'b1101) begin
                    state <= DELAY_DETECTION;
                    pattern <= 4'd0;
                    bit_counter <= 3'd0;
                end
            end
            DELAY_DETECTION: begin
                if (bit_counter < 3'd4) begin
                    delay_reg <= {data, delay_reg[3:1]};
                    bit_counter <= bit_counter + 1;
                end
                if (bit_counter == 3'd4) begin
                    state <= COUNTING;
                    counter <= (delay_reg + 1) * 1000 - 1;
                    counting <= 1'b1;
                end
            end
            COUNTING: begin
                if (counter > 20'd0) begin
                    counter <= counter - 1;
                    if (counter % 1000 == 0 && counter!= 20'd0) begin
                        delay_reg <= delay_reg - 1;
                    end
                end
                if (counter == 20'd0) begin
                    state <= DONE;
                    counting <= 1'b0;
                    done <= 1'b1;
                end
            end
            DONE: begin
                if (ack) begin
                    state <= IDLE;
                    counter <= 20'd0;
                    delay_reg <= 4'd0;
                    pattern <= 4'd0;
                    bit_counter <= 3'd0;
                    done <= 1'b0;
                end
            end
        endcase
    end
    if (state == COUNTING) begin
        count <= delay_reg;
    end
end

endmodule