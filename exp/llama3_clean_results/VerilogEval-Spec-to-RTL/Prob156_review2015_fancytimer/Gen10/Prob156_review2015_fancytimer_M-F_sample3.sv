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
reg [2:0] state;
reg [3:0] remaining_time;
reg [1:0] delay_counter;

parameter IDLE = 3'b001;
parameter DELAY_DETECTION = 3'b010;
parameter COUNTING = 3'b100;
parameter DONE = 3'b111;

assign counting = (state == COUNTING);

always @(posedge clk or posedge reset) begin
    if (reset) begin
        state <= IDLE;
        delay_reg <= 4'd0;
        counter <= 20'd0;
        pattern <= 4'd0;
        remaining_time <= 4'd0;
        delay_counter <= 2'd0;
        count <= 4'd0;
    end
    else begin
        case (state)
            IDLE: begin
                pattern <= {pattern[2:0], data};
                if (pattern == 4'b1101) begin
                    state <= DELAY_DETECTION;
                    pattern <= 4'd0;
                end
            end
            DELAY_DETECTION: begin
                delay_reg <= {delay_reg[2:0], data};
                delay_counter <= delay_counter + 1;
                if (delay_counter == 2'd4) begin
                    remaining_time <= delay_reg;
                    counter <= (delay_reg + 1) * 1000 - 1;
                    state <= COUNTING;
                    delay_counter <= 2'd0;
                end
            end
            COUNTING: begin
                if (counter >= 20'd0) begin
                    counter <= counter - 1;
                    if (counter % 1000 == 999) begin
                        remaining_time <= remaining_time - 1;
                    end
                end
                else begin
                    state <= DONE;
                end
            end
            DONE: begin
                if (ack) begin
                    state <= IDLE;
                    counter <= 20'd0;
                    delay_reg <= 4'd0;
                    pattern <= 4'd0;
                    remaining_time <= 4'd0;
                    delay_counter <= 2'd0;
                    count <= 4'd0;
                end
            end
        endcase
    end
end

assign done = (state == DONE);
assign count = (state == COUNTING)? remaining_time : 4'bx;

endmodule