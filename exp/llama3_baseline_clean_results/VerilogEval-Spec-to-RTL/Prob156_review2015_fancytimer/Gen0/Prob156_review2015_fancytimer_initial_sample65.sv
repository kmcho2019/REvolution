module TopModule(
    input  clk,
    input  reset,
    input  data,
    output [3:0] count,
    output counting,
    output done,
    input  ack
);

reg [3:0] delay;
reg [3:0] countdown;
reg [9:0] counter;
reg [3:0] shift_reg;
reg [1:0] state;
reg counting_reg;
reg done_reg;

parameter IDLE = 2'b00;
parameter SHIFT = 2'b01;
parameter COUNT = 2'b10;
parameter DONE = 2'b11;

always @(posedge clk) begin
    if (reset) begin
        state <= IDLE;
        countdown <= 0;
        counter <= 0;
        shift_reg <= 0;
        delay <= 0;
        counting_reg <= 0;
        done_reg <= 0;
    end else begin
        case (state)
            IDLE: begin
                if (data) begin
                    shift_reg <= {shift_reg[2:0], 1'b1};
                end else begin
                    shift_reg <= {shift_reg[2:0], 1'b0};
                end
                if (shift_reg == 4'b1101) begin
                    state <= SHIFT;
                end
            end
            SHIFT: begin
                delay <= {data, delay[3:1]};
                if (counter == 4'd3) begin
                    state <= COUNT;
                    countdown <= (delay + 1) * 10'd1000;
                    counter <= 0;
                    counting_reg <= 1;
                end else begin
                    counter <= counter + 1;
                end
            end
            COUNT: begin
                if (countdown == 0) begin
                    state <= DONE;
                    done_reg <= 1;
                    counting_reg <= 0;
                end else begin
                    countdown <= countdown - 1;
                end
            end
            DONE: begin
                if (ack) begin
                    state <= IDLE;
                    done_reg <= 0;
                end
            end
        endcase
    end
end

assign count = (state == COUNT) ? delay - (9'd999 - counter) / 10'd1000 : 4'bxxxx;
assign counting = counting_reg;
assign done = done_reg;

endmodule