module TopModule(
    input clk,
    input reset,
    input data,
    output [3:0] count,
    output counting,
    output done,
    input ack
);

reg [3:0] delay;
reg [3:0] counter;
reg [3:0] remaining;
reg [3:0] shift_reg;
reg [2:0] state;
reg [10:0] timer;

parameter IDLE = 3'b000;
parameter SHIFT = 3'b001;
parameter COUNTING = 3'b010;
parameter DONE = 3'b011;

always @(posedge clk or posedge reset) begin
    if (reset) begin
        state <= IDLE;
        delay <= 4'd0;
        counter <= 4'd0;
        remaining <= 4'd0;
        shift_reg <= 4'd0;
        timer <= 11'd0;
        count <= 4'd0;
        counting <= 1'b0;
        done <= 1'b0;
    end
    else begin
        case (state)
            IDLE: begin
                if (data) begin
                    shift_reg <= {shift_reg[2:0], 1'b1};
                    if (shift_reg == 4'b1101) begin
                        state <= SHIFT;
                        shift_reg <= 4'd0;
                    end
                end
                else begin
                    shift_reg <= {shift_reg[2:0], 1'b0};
                end
            end
            SHIFT: begin
                shift_reg <= {shift_reg[2:0], data};
                if (shift_reg[0]) begin
                    state <= COUNTING;
                    delay <= shift_reg;
                    remaining <= delay;
                    timer <= 11'd0;
                    counting <= 1'b1;
                end
            end
            COUNTING: begin
                if (timer == 11'd999) begin
                    timer <= 11'd0;
                    remaining <= remaining - 1;
                    if (remaining == 4'd0) begin
                        state <= DONE;
                        counting <= 1'b0;
                        done <= 1'b1;
                    end
                end
                else begin
                    timer <= timer + 11'd1;
                end
                count <= remaining;
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

endmodule