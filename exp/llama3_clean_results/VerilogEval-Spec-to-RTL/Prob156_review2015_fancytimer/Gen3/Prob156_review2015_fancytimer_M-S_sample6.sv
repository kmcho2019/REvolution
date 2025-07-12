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
reg shift_counter;

parameter IDLE = 2'b00;
parameter SHIFT_IN = 2'b01;
parameter COUNTING = 2'b10;
parameter DONE_STATE = 2'b11;

reg [1:0] state;

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
        case (state)
            IDLE: begin
                if (data) begin
                    pattern_reg <= {pattern_reg[2:0], 1'b1};
                    if (pattern_reg == 4'b1101) begin
                        state <= SHIFT_IN;
                        pattern_reg <= 4'd0;
                        shift_counter <= 4'd0;
                    end
                end
                else begin
                    pattern_reg <= {pattern_reg[2:0], 1'b0};
                end
            end
            SHIFT_IN: begin
                pattern_reg <= {pattern_reg[2:0], data};
                shift_counter <= shift_counter + 1;
                if (shift_counter == 4'd4) begin
                    delay <= pattern_reg;
                    state <= COUNTING;
                    remaining <= delay + 1;
                    timer <= 10'd0;
                    counting <= 1'b1;
                end
            end
            COUNTING: begin
                timer <= timer + 10'd1;
                if (timer == 10'd999) begin
                    timer <= 10'd0;
                    remaining <= remaining - 1;
                    count <= remaining - 1;
                    if (remaining == 4'd1) begin
                        state <= DONE_STATE;
                        counting <= 1'b0;
                        done <= 1'b1;
                    end
                end
            end
            DONE_STATE: begin
                if (ack) begin
                    state <= IDLE;
                    done <= 1'b0;
                end
            end
        endcase
    end
end

endmodule