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
reg [11:0] counter;
reg [3:0] count_reg;
reg [3:0] pattern;
reg counting_reg;
reg done_reg;
reg [1:0] state; // 0: IDLE, 1: SHIFT, 2: COUNT, 3: DONE

initial state = 0;
initial delay = 0;
initial counter = 0;
initial count_reg = 0;
initial counting_reg = 0;
initial done_reg = 0;

always @(posedge clk) begin
    if (reset) begin
        state <= 0;
        delay <= 0;
        counter <= 0;
        count_reg <= 0;
        counting_reg <= 0;
        done_reg <= 0;
        pattern <= 0;
    end else begin
        case (state)
            0: begin // IDLE
                if (pattern == 4'b1101) begin
                    state <= 1;
                    pattern <= 0;
                end else if (data) begin
                    pattern <= {pattern[2:0], 1'b1};
                end else begin
                    pattern <= {pattern[2:0], 1'b0};
                end
            end
            1: begin // SHIFT
                delay <= {delay[2:0], data};
                state <= (delay[3:0] == 4'b1111) ? 2 : 1;
            end
            2: begin // COUNT
                counting_reg <= 1;
                if (counter == ((delay + 1) * 1000 - 1)) begin
                    state <= 3;
                    counter <= 0;
                    counting_reg <= 0;
                end else begin
                    counter <= counter + 1;
                    if (counter % 1000 == 0) begin
                        count_reg <= count_reg - 1;
                    end
                end
            end
            3: begin // DONE
                done_reg <= 1;
                if (ack) begin
                    state <= 0;
                    done_reg <= 0;
                    count_reg <= 0;
                end
            end
        endcase
    end
end

assign count = count_reg;
assign counting = counting_reg;
assign done = done_reg;

endmodule