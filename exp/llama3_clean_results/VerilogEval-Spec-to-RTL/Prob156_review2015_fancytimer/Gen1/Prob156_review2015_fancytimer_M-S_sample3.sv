module TopModule(
    input  clk,
    input  reset,
    input  data,
    output [3:0] count,
    output counting,
    output done,
    input  ack
);

reg [2:0] state; // 0: IDLE, 1: SHIFT, 2: COUNT, 3: DONE (modified to 3 bits)
reg [3:0] delay;
reg [11:0] counter;
reg counting_reg;
reg done_reg;

always @(posedge clk) begin
    if (reset) begin
        state <= 0;
        delay <= 0;
        counter <= 0;
        counting_reg <= 0;
        done_reg <= 0;
    end else begin
        case (state)
            0: begin // IDLE
                if (data == 1'b1) begin
                    delay[0] <= 1'b1;
                    state <= 1;
                end else if (data == 1'b0) begin
                    delay[0] <= 1'b0;
                end
                if (delay == 4'b1101) begin
                    state <= 1;
                end
            end
            1: begin // SHIFT
                if (counter == 0) begin
                    counter <= 3;
                    delay[3:1] <= {data, delay[3:2]};
                end else begin
                    counter <= counter - 1;
                    delay[3:1] <= {data, delay[3:2]};
                    if (counter == 0) begin
                        state <= 2;
                        counter <= ((delay + 1) * 1000) - 1;
                        counting_reg <= 1;
                    end
                end
            end
            2: begin // COUNT
                if (counter == 0) begin
                    state <= 3;
                    counting_reg <= 0;
                    done_reg <= 1;
                end else begin
                    counter <= counter - 1;
                    count <= delay - (counter[11:3] / 1000);
                end
            end
            3: begin // DONE
                if (ack) begin
                    state <= 0;
                    done_reg <= 0;
                end
            end
        endcase
    end
end

assign counting = counting_reg;
assign done = done_reg;

endmodule