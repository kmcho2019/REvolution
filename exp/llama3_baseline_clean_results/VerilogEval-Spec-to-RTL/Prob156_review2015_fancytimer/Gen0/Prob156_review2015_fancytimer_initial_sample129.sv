module TopModule(
    input clk,
    input reset,
    input data,
    output [3:0] count,
    output counting,
    output done,
    input ack
);

reg [3:0] state; // current state
reg [3:0] delay; // delay value
reg [3:0] remaining_time; // remaining time
reg [11:0] counter; // counter for total clock cycles
reg [3:0] pattern; // input pattern
reg counting_reg; // counting signal
reg done_reg; // done signal

// State encoding
parameter IDLE = 4'b0000;
parameter SHIFT_DELAY = 4'b0001;
parameter COUNTING = 4'b0010;
parameter DONE = 4'b0011;

// Shift in 4 bits to determine the duration of the timer delay
reg [3:0] shift_counter;

always @(posedge clk) begin
    if (reset) begin
        state <= IDLE;
        delay <= 4'b0000;
        remaining_time <= 4'b0000;
        counter <= 12'b0000;
        pattern <= 4'b0000;
        counting_reg <= 1'b0;
        done_reg <= 1'b0;
        shift_counter <= 4'b0000;
    end else begin
        case (state)
            IDLE: begin
                if (pattern == 4'b1101) begin
                    state <= SHIFT_DELAY;
                    pattern <= 4'b0000;
                    shift_counter <= 4'b0000;
                end else begin
                    pattern <= {pattern[2:0], data};
                end
            end
            SHIFT_DELAY: begin
                if (shift_counter == 4'b1000) begin
                    state <= COUNTING;
                    remaining_time <= delay;
                    counter <= 12'b0000;
                end else begin
                    delay <= {data, delay[3:1]};
                    shift_counter <= shift_counter + 1'b1;
                end
            end
            COUNTING: begin
                if (counter == (delay + 1'b1) * 12'b1000) begin
                    state <= DONE;
                    done_reg <= 1'b1;
                    counting_reg <= 1'b0;
                end else begin
                    if (counter % 12'b1000 == 12'b0000) begin
                        remaining_time <= remaining_time - 1'b1;
                    end
                    counter <= counter + 1'b1;
                    counting_reg <= 1'b1;
                end
            end
            DONE: begin
                if (ack) begin
                    state <= IDLE;
                    done_reg <= 1'b0;
                end
            end
            default: begin
                state <= IDLE;
            end
        endcase
    end
end

assign count = (state == COUNTING)? remaining_time : 4'bxxxx;
assign counting = counting_reg;
assign done = done_reg;

endmodule