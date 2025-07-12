module TopModule(
    input  clk,
    input  reset,
    input  data,
    output [3:0] count,
    output counting,
    output done,
    input  ack
);

reg [3:0] state; // 0: idle, 1: shift, 2: count, 3: done
reg [3:0] delay; // delay value
reg [3:0] current_count; // current count
reg [9:0] timer; // timer for counting
reg counting_reg;
reg done_reg;

always @(posedge clk) begin
    if (reset) begin
        state <= 0;
        delay <= 0;
        current_count <= 0;
        timer <= 0;
        counting_reg <= 0;
        done_reg <= 0;
    end else begin
        case (state)
            0: begin // idle
                if (data == 1) begin
                    state <= 1;
                end
            end
            1: begin // shift
                if (data == 1) begin
                    state <= 2;
                end else if (data == 0) begin
                    state <= 0;
                end
            end
            2: begin // shift
                delay[3] <= data;
                state <= 3;
            end
            3: begin // shift
                delay[2] <= data;
                state <= 4;
            end
            4: begin // shift
                delay[1] <= data;
                state <= 5;
            end
            5: begin // shift
                delay[0] <= data;
                state <= 6;
                timer <= 0;
                current_count <= delay + 1;
                counting_reg <= 1;
            end
            6: begin // count
                timer <= timer + 1;
                if (timer == 999) begin
                    timer <= 0;
                    if (current_count > 1) begin
                        current_count <= current_count - 1;
                    end else begin
                        counting_reg <= 0;
                        state <= 7;
                    end
                end
            end
            7: begin // done
                done_reg <= 1;
                if (ack) begin
                    done_reg <= 0;
                    state <= 0;
                end
            end
        endcase
    end
end

assign count = (state == 6) ? current_count : 4'bxxxx;
assign counting = counting_reg;
assign done = done_reg;

endmodule