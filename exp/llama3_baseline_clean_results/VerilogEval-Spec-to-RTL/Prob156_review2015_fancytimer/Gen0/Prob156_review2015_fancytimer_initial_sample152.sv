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
reg [3:0] delay;
reg [3:0] count_reg;
reg [3:0] shift_reg;
reg [9:0] counter;
reg counting_reg;
reg done_reg;

always @(posedge clk or posedge reset) begin
    if (reset) begin
        state <= 0; // IDLE
        delay <= 0;
        count_reg <= 0;
        shift_reg <= 0;
        counter <= 0;
        counting_reg <= 0;
        done_reg <= 0;
    end else begin
        case (state)
            0: begin // IDLE
                if (shift_reg == 4'd13) begin // 1101
                    state <= 1; // SHIFTING
                    shift_reg <= 0;
                end else if (data == 1'b1) begin
                    shift_reg <= {shift_reg[2:0], 1'b1};
                end else begin
                    shift_reg <= {shift_reg[2:0], 1'b0};
                end
            end
            1: begin // SHIFTING
                delay <= {delay[2:0], data};
                state <= state + 1;
                if (state == 5) begin // COUNTING
                    state <= 2;
                    counter <= (delay + 1) * 1000 - 1;
                    counting_reg <= 1;
                end
            end
            2: begin // COUNTING
                if (counter == 0) begin
                    state <= 3; // DONE
                    counting_reg <= 0;
                    done_reg <= 1;
                end else begin
                    counter <= counter - 1;
                    count_reg <= delay - (999 - counter[9:3]);
                end
            end
            3: begin // DONE
                if (ack == 1'b1) begin
                    state <= 0; // IDLE
                    done_reg <= 0;
                end
            end
        endcase
    end
end

assign count = (state == 2) ? count_reg : 4'd0;
assign counting = counting_reg;
assign done = done_reg;

endmodule