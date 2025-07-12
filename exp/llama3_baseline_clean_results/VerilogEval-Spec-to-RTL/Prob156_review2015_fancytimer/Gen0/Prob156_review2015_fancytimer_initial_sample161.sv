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
reg [3:0] remaining_time;
reg [15:0] counter;
reg [3:0] shift_counter;
reg [3:0] state;
reg [3:0] pattern;
reg counting_reg;
reg done_reg;

parameter IDLE = 4'b0000;
parameter SHIFT = 4'b0001;
parameter COUNT = 4'b0010;
parameter DONE = 4'b0011;

always @ (posedge clk) begin
    if (reset) begin
        state <= IDLE;
        pattern <= 4'b0000;
        shift_counter <= 4'b0000;
        counter <= 16'b0000;
        delay <= 4'b0000;
        remaining_time <= 4'b0000;
        counting_reg <= 1'b0;
        done_reg <= 1'b0;
    end else begin
        case (state)
            IDLE: begin
                if (data == 1'b1) begin
                    pattern <= {pattern[2:0], 1'b1};
                    if (pattern == 4'b1101) begin
                        state <= SHIFT;
                    end
                end else begin
                    pattern <= {pattern[2:0], 1'b0};
                end
            end
            SHIFT: begin
                delay[3-shift_counter] <= data;
                shift_counter <= shift_counter + 1;
                if (shift_counter == 4'b0100) begin
                    state <= COUNT;
                    counter <= 16'b0000;
                    remaining_time <= delay;
                    counting_reg <= 1'b1;
                end
            end
            COUNT: begin
                counter <= counter + 1;
                if (counter == 16'b1111111111111000) begin // 1000 clock cycles
                    counter <= 16'b0000;
                    remaining_time <= remaining_time - 1;
                    if (remaining_time == 4'b0000) begin
                        state <= DONE;
                        counting_reg <= 1'b0;
                    end
                end
            end
            DONE: begin
                done_reg <= 1'b1;
                if (ack == 1'b1) begin
                    state <= IDLE;
                    pattern <= 4'b0000;
                    shift_counter <= 4'b0000;
                    counter <= 16'b0000;
                    delay <= 4'b0000;
                    remaining_time <= 4'b0000;
                    done_reg <= 1'b0;
                end
            end
            default: state <= IDLE;
        endcase
    end
end

assign count = remaining_time;
assign counting = counting_reg;
assign done = done_reg;

endmodule