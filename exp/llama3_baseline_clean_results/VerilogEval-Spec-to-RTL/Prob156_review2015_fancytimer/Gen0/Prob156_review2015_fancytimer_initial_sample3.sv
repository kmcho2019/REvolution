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
reg [3:0] remaining;
reg [3:0] counter;
reg [3:0] shift_counter;
reg [3:0] pattern;
reg counting_reg;
reg done_reg;
reg [1:0] state;

parameter IDLE = 2'b00;
parameter SHIFT = 2'b01;
parameter COUNT = 2'b10;
parameter DONE = 2'b11;

always @(posedge clk or posedge reset) begin
    if (reset) begin
        state <= IDLE;
        pattern <= 0;
        shift_counter <= 0;
        counter <= 0;
        remaining <= 0;
        delay <= 0;
        counting_reg <= 0;
        done_reg <= 0;
    end else begin
        case (state)
            IDLE: begin
                if (data == 1) begin
                    pattern <= {pattern[2:0], 1};
                end else begin
                    pattern <= {pattern[2:0], 0};
                end
                if (pattern == 4'b1101) begin
                    state <= SHIFT;
                    pattern <= 0;
                end
            end
            SHIFT: begin
                delay <= {delay[2:0], data};
                shift_counter <= shift_counter + 1;
                if (shift_counter == 4) begin
                    state <= COUNT;
                    remaining <= delay + 1;
                    counter <= 0;
                    counting_reg <= 1;
                end
            end
            COUNT: begin
                counter <= counter + 1;
                if (counter == 1000) begin
                    counter <= 0;
                    remaining <= remaining - 1;
                    if (remaining == 0) begin
                        state <= DONE;
                        counting_reg <= 0;
                    end
                end
                count <= remaining;
            end
            DONE: begin
                done_reg <= 1;
                if (ack) begin
                    state <= IDLE;
                    done_reg <= 0;
                end
            end
        endcase
    end
end

assign counting = counting_reg;
assign done = done_reg;

endmodule