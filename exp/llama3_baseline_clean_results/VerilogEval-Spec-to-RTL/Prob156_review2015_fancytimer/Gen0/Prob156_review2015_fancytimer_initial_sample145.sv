module TopModule(
    input clk,
    input reset,
    input data,
    output [3:0] count,
    output counting,
    output done,
    input ack
);

reg [3:0] state;
parameter IDLE = 4'b0000, SHIFT = 4'b0001, COUNT = 4'b0010, DONE = 4'b0011;
reg [3:0] delay;
reg [3:0] remaining;
reg [9:0] counter;
reg [3:0] pattern;
reg shift_pattern;
reg [2:0] shift_counter;

always @(posedge clk) begin
    if (reset) begin
        state <= IDLE;
        counting <= 0;
        done <= 0;
        pattern <= 0;
        shift_pattern <= 0;
        shift_counter <= 0;
        counter <= 0;
        remaining <= 0;
        delay <= 0;
    end else begin
        case (state)
            IDLE: begin
                if (pattern == 4'b1101) begin
                    state <= SHIFT;
                    shift_pattern <= 1;
                    shift_counter <= 0;
                end else if (data) begin
                    pattern <= {pattern[2:0], 1'b1};
                end else begin
                    pattern <= {pattern[2:0], 1'b0};
                end
            end
            SHIFT: begin
                delay[3-shift_counter] <= data;
                shift_counter <= shift_counter + 1;
                if (shift_counter == 4) begin
                    state <= COUNT;
                    remaining <= delay;
                    counter <= 0;
                    counting <= 1;
                end
            end
            COUNT: begin
                counter <= counter + 1;
                if (counter == 1000) begin
                    counter <= 0;
                    remaining <= remaining - 1;
                    if (remaining == 0) begin
                        state <= DONE;
                        done <= 1;
                        counting <= 0;
                    end
                end
            end
            DONE: begin
                if (ack) begin
                    state <= IDLE;
                    done <= 0;
                    pattern <= 0;
                end
            end
        endcase
    end
end

assign count = (state == COUNT) ? remaining : 4'bxxxx;

endmodule