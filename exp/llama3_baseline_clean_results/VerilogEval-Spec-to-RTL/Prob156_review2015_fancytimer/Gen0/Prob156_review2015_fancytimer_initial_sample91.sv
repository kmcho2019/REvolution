module TopModule (
    input clk,
    input reset,
    input data,
    output [3:0] count,
    output counting,
    output done,
    input ack
);

reg [3:0] state;
reg [3:0] delay;
reg [3:0] remaining;
reg [9:0] counter;
reg counting_reg;
reg done_reg;

parameter IDLE = 4'd0;
parameter SHIFT = 4'd1;
parameter COUNT = 4'd2;
parameter DONE = 4'd3;

reg [3:0] shift_reg;

always @(posedge clk) begin
    if (reset) begin
        state <= IDLE;
        shift_reg <= 4'd0;
        counter <= 10'd0;
        remaining <= 4'd0;
        counting_reg <= 1'b0;
        done_reg <= 1'b0;
    end else begin
        case (state)
            IDLE: begin
                if (shift_reg == 4'd13) begin
                    state <= SHIFT;
                    shift_reg <= 4'd0;
                end else if (data) begin
                    shift_reg <= {shift_reg[2:0], 1'b1};
                end else if (~data) begin
                    shift_reg <= {shift_reg[2:0], 1'b0};
                end else begin
                    shift_reg <= shift_reg;
                end
            end
            SHIFT: begin
                delay <= {delay[2:0], data};
                state <= COUNT;
                remaining <= delay + 1;
                counting_reg <= 1'b1;
                counter <= 10'd999;
            end
            COUNT: begin
                if (counter == 10'd0) begin
                    if (remaining == 4'd1) begin
                        state <= DONE;
                        done_reg <= 1'b1;
                        counting_reg <= 1'b0;
                    end else begin
                        remaining <= remaining - 1;
                        counter <= 10'd999;
                    end
                end else begin
                    counter <= counter - 1;
                end
            end
            DONE: begin
                if (ack) begin
                    state <= IDLE;
                    done_reg <= 1'b0;
                    shift_reg <= 4'd0;
                end
            end
        endcase
    end
end

assign counting = counting_reg;
assign done = done_reg;
assign count = remaining;

endmodule