module TopModule (
    input  clk,
    input  reset,
    input  data,
    output [3:0] count,
    output counting,
    output done,
    input  ack
);

reg [3:0] delay;
reg [3:0] counter;
reg [9:0] clock_counter;
reg [3:0] state;
reg [3:0] count_out;
reg counting_out;
reg done_out;

parameter IDLE = 4'd0;
parameter SHIFT = 4'd1;
parameter COUNTING = 4'd2;
parameter DONE = 4'd3;

reg [3:0] pattern;
reg [3:0] shift_counter;

always @(posedge clk) begin
    if (reset) begin
        state <= IDLE;
        pattern <= 4'd0;
        shift_counter <= 4'd0;
        delay <= 4'd0;
        counter <= 4'd0;
        clock_counter <= 10'd0;
        count_out <= 4'd0;
        counting_out <= 1'b0;
        done_out <= 1'b0;
    end
    else begin
        case (state)
            IDLE: begin
                pattern <= {pattern[2:0], data};
                if (pattern == 4'd13) begin
                    state <= SHIFT;
                    shift_counter <= 4'd0;
                end
            end
            SHIFT: begin
                delay <= {delay[2:0], data};
                shift_counter <= shift_counter + 1;
                if (shift_counter == 4'd4) begin
                    state <= COUNTING;
                    counter <= delay + 1;
                    clock_counter <= 10'd0;
                    count_out <= delay;
                end
            end
            COUNTING: begin
                clock_counter <= clock_counter + 1;
                if (clock_counter == 10'd1000) begin
                    clock_counter <= 10'd0;
                    counter <= counter - 1;
                    count_out <= count_out - 1;
                    if (counter == 4'd0) begin
                        state <= DONE;
                    end
                end
            end
            DONE: begin
                if (ack) begin
                    state <= IDLE;
                end
            end
        endcase
        counting_out <= (state == COUNTING);
        done_out <= (state == DONE);
    end
end

assign count = (state == COUNTING) ? count_out : 4'd0;
assign counting = counting_out;
assign done = done_out;

endmodule