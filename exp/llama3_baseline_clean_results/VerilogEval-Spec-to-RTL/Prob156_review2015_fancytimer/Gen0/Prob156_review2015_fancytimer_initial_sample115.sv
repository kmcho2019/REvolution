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
reg [3:0] count_reg;
reg [9:0] counter;
reg [3:0] state; // 0 - idle, 1 - shift, 2 - counting, 3 - done
reg [3:0] shift_reg;
reg [3:0] pattern;

always @(posedge clk) begin
    if (reset) begin
        state <= 0;
        delay <= 0;
        count_reg <= 0;
        counter <= 0;
        shift_reg <= 0;
        pattern <= 0;
        done <= 0;
        counting <= 0;
    end else begin
        case (state)
            0: begin // idle
                if (data == 1) begin
                    pattern[0] <= 1;
                end else begin
                    pattern[0] <= 0;
                end
                if (pattern == 4'b1101) begin
                    state <= 1;
                    shift_reg <= 0;
                end else begin
                    pattern <= {pattern[2:0], pattern[3]};
                end
            end
            1: begin // shift
                shift_reg <= {shift_reg[2:0], data};
                if (shift_reg[3] == 1'b1) begin
                    state <= 2;
                    delay <= shift_reg;
                    count_reg <= delay;
                    counter <= 0;
                    counting <= 1;
                end
            end
            2: begin // counting
                counter <= counter + 1;
                if (counter == 1000) begin
                    counter <= 0;
                    count_reg <= count_reg - 1;
                    if (count_reg == 0) begin
                        state <= 3;
                        counting <= 0;
                        done <= 1;
                    end
                end
            end
            3: begin // done
                if (ack) begin
                    state <= 0;
                    done <= 0;
                end
            end
        endcase
    end
end

assign count = (state == 2) ? count_reg : 4'bxxxx;

endmodule