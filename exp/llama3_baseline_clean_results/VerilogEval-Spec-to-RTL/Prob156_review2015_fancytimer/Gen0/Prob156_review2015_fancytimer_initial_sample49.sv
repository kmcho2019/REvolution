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
reg [3:0] counter;
reg [3:0] remaining;
reg [3:0] pattern;
reg counting_reg;
reg done_reg;
reg [1:0] state;

always @(posedge clk) begin
    if (reset) begin
        state <= 0;
        counting_reg <= 0;
        done_reg <= 0;
        counter <= 0;
        remaining <= 0;
        pattern <= 0;
    end else begin
        case (state)
            0: begin // idle
                if (data) begin
                    pattern[0] <= 1;
                end else begin
                    pattern[0] <= 0;
                end
                if (pattern == 4'b1101) begin
                    state <= 1;
                    pattern <= 0;
                end
            end
            1: begin // shifting in delay bits
                pattern <= {pattern[2:0], data};
                if (pattern[3] == 1) begin
                    delay <= pattern;
                    state <= 2;
                    counter <= 0;
                    remaining <= delay;
                end
            end
            2: begin // counting down timer
                counting_reg <= 1;
                if (counter == 1000) begin
                    counter <= 0;
                    remaining <= remaining - 1;
                    if (remaining == 0) begin
                        state <= 3;
                    end
                end else begin
                    counter <= counter + 1;
                end
                count <= remaining;
            end
            3: begin // waiting for acknowledgment
                done_reg <= 1;
                counting_reg <= 0;
                if (ack) begin
                    state <= 0;
                    done_reg <= 0;
                end
            end
            default: begin
                state <= 0;
            end
        endcase
    end
end

assign counting = counting_reg;
assign done = done_reg;

endmodule