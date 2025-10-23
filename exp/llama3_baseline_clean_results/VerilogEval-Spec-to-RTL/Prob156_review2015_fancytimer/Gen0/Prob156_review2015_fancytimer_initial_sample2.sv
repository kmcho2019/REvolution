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
reg [3:0] count_reg;
reg [3:0] shift_reg;
reg counting_reg;
reg done_reg;
reg [1:0] state;

always @(posedge clk) begin
    if (reset) begin
        state <= 0;
        counting_reg <= 0;
        done_reg <= 0;
        counter <= 0;
        count_reg <= 0;
        shift_reg <= 0;
    end else begin
        case (state)
            0: begin // idle
                if (shift_reg == 4'b1101) begin
                    state <= 1;
                    shift_reg <= 0;
                end else if (data) begin
                    shift_reg <= {shift_reg[2:0], 1'b1};
                end else begin
                    shift_reg <= {shift_reg[2:0], 1'b0};
                end
            end
            1: begin // delay
                if (shift_reg == 4'b1000) begin
                    state <= 2;
                    delay <= shift_reg;
                    counter <= (delay + 1) * 1000;
                    count_reg <= delay;
                end else begin
                    shift_reg <= {data, shift_reg[3:1]};
                end
            end
            2: begin // counting
                counting_reg <= 1;
                if (counter == 0) begin
                    state <= 3;
                    counting_reg <= 0;
                end else if (counter % 1000 == 0) begin
                    count_reg <= count_reg - 1;
                end
                counter <= counter - 1;
            end
            3: begin // done
                done_reg <= 1;
                if (ack) begin
                    state <= 0;
                    done_reg <= 0;
                end
            end
        endcase
    end
end

assign count = (state == 2) ? count_reg : 4'bxxxx;
assign counting = counting_reg;
assign done = done_reg;

endmodule