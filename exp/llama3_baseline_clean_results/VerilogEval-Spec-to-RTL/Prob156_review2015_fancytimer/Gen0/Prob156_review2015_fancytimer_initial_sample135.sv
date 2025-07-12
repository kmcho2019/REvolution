module TopModule(
    input           clk,
    input           reset,
    input           data,
    output  [3:0]   count,
    output          counting,
    output          done,
    input           ack
);

reg [3:0]         delay;
reg [3:0]         counter;
reg [9:0]         countdown;
reg [3:0]         remaining;
reg               searching;
reg               counting_state;
reg               done_state;

always @(posedge clk) begin
    if (reset) begin
        searching <= 1'b1;
        counting_state <= 1'b0;
        done_state <= 1'b0;
        countdown <= 10'b0;
        remaining <= 4'b0;
        delay <= 4'b0;
    end else begin
        if (searching) begin
            if (data) begin
                // looking for 1101 pattern
                if (delay == 4'b1) begin
                    delay <= delay + 1'b1;
                end else if (delay == 4'b2) begin
                    if (data) begin
                        delay <= delay + 1'b1;
                    end else begin
                        delay <= 4'b0;
                    end
                end else if (delay == 4'b3) begin
                    if (data == 1'b0) begin
                        delay <= delay + 1'b1;
                    end else begin
                        delay <= 4'b0;
                    end
                end else if (delay == 4'b4) begin
                    if (data == 1'b1) begin
                        // pattern found, shift in delay
                        searching <= 1'b0;
                        counting_state <= 1'b1;
                        countdown <= {6'b0, delay} + 4'b1;
                        remaining <= delay;
                    end else begin
                        delay <= 4'b0;
                    end
                end
            end else begin
                delay <= 4'b0;
            end
        end else if (counting_state) begin
            if (countdown != 10'b0) begin
                countdown <= countdown - 1'b1;
                if (countdown[0] == 1'b0) begin
                    remaining <= remaining - 1'b1;
                end
            end else begin
                counting_state <= 1'b0;
                done_state <= 1'b1;
            end
        end else if (done_state) begin
            if (ack) begin
                done_state <= 1'b0;
                searching <= 1'b1;
            end
        end
    end
end

assign count = (counting_state) ? remaining : 4'bx;
assign counting = counting_state;
assign done = done_state;

endmodule