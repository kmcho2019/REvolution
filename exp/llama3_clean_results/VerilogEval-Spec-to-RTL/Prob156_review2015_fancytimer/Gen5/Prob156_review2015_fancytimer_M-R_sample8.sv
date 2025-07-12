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
reg [9:0] timer;
reg [3:0] remaining;
reg [3:0] pattern_reg;
reg [3:0] shift_counter;

localparam IDLE = 2'b00;
localparam SHIFT_IN = 2'b01;
localparam COUNTING = 2'b10;
localparam DONE_STATE = 2'b11;

reg [1:0] state;
reg [1:0] next_state;

always @(*) begin
    case (state)
        IDLE: begin
            if (data) begin
                pattern_reg = {pattern_reg[2:0], 1'b1};
                if (pattern_reg == 4'b1101) begin
                    next_state = SHIFT_IN;
                end
                else begin
                    next_state = IDLE;
                end
            end
            else begin
                pattern_reg = {pattern_reg[2:0], 1'b0};
                next_state = IDLE;
            end
        end
        SHIFT_IN: begin
            delay = {delay[2:0], data};
            shift_counter = shift_counter + 1;
            if (shift_counter == 4'd4) begin
                next_state = COUNTING;
            end
            else begin
                next_state = SHIFT_IN;
            end
        end
        COUNTING: begin
            if (timer == 10'd999) begin
                timer = 10'd0;
                remaining = remaining - 1;
                if (remaining == 4'd0) begin
                    next_state = DONE_STATE;
                end
                else begin
                    next_state = COUNTING;
                end
            end
            else begin
                next_state = COUNTING;
            end
        end
        DONE_STATE: begin
            if (ack) begin
                next_state = IDLE;
            end
            else begin
                next_state = DONE_STATE;
            end
        end
    endcase
end

always @(posedge clk or posedge reset) begin
    if (reset) begin
        state <= IDLE;
        delay <= 4'd0;
        remaining <= 4'd0;
        timer <= 10'd0;
        pattern_reg <= 4'd0;
        shift_counter <= 4'd0;
        counting <= 1'b0;
        done <= 1'b0;
        count <= 4'd0;
    end
    else begin
        state <= next_state;
        if (state == SHIFT_IN) begin
            shift_counter <= shift_counter;
        end
        else if (state == COUNTING) begin
            timer <= timer + 1;
        end
        else begin
            timer <= 10'd0;
        end
        if (state == COUNTING) begin
            remaining <= delay + 1;
        end
        else if (state == DONE_STATE) begin
            remaining <= 4'd0;
        end
        counting <= (state == COUNTING) ? 1'b1 : 1'b0;
        done <= (state == DONE_STATE) ? 1'b1 : 1'b0;
    end
end

assign count = remaining;
endmodule