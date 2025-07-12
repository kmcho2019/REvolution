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
reg [9:0] counter;
reg [3:0] remaining_time;
reg counting_reg;
reg done_reg;

enum {IDLE, SHIFT, COUNT, DONE} state, next_state;

always @(posedge clk) begin
    if (reset) begin
        state <= IDLE;
        delay <= 4'b0;
        counter <= 10'b0;
        remaining_time <= 4'b0;
        counting_reg <= 1'b0;
        done_reg <= 1'b0;
    end else begin
        case (state)
            IDLE: begin
                if (data == 1'b1) begin
                    // Check for the pattern 1101
                    if (~counter[1:0] && data) begin
                        if (counter[9:2] == 8'b1101) begin
                            next_state <= SHIFT;
                        end else begin
                            counter <= counter + 1'b1;
                        end
                    end else begin
                        counter <= {1'b1, counter[9:1]};
                    end
                end else begin
                    counter <= {1'b1, counter[9:1]};
                end
            end
            SHIFT: begin
                // Shift in the next 4 bits
                delay <= {data, delay[3:1]};
                if (counter == 10'd4) begin
                    next_state <= COUNT;
                    counter <= 10'b0;
                    remaining_time <= delay + 1'b1;
                    counting_reg <= 1'b1;
                end else begin
                    counter <= counter + 1'b1;
                end
            end
            COUNT: begin
                // Count for exactly (delay[3:0] + 1) * 1000 clock cycles
                if (counter == 10'd1000) begin
                    remaining_time <= remaining_time - 1'b1;
                    counter <= 10'b0;
                    if (remaining_time == 4'b0) begin
                        next_state <= DONE;
                        counting_reg <= 1'b0;
                    end
                end else begin
                    counter <= counter + 1'b1;
                end
            end
            DONE: begin
                // Assert done and wait for ack
                done_reg <= 1'b1;
                if (ack) begin
                    next_state <= IDLE;
                    done_reg <= 1'b0;
                end
            end
        endcase
        state <= next_state;
    end
end

assign count = remaining_time;
assign counting = counting_reg;
assign done = done_reg;

endmodule