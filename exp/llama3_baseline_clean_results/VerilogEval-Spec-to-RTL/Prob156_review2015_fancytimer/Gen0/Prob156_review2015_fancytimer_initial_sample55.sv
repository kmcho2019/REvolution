module TopModule(
    input  clk,
    input  reset,
    input  data,
    output reg [3:0] count,
    output reg counting,
    output reg done,
    input  ack
);

reg [3:0] delay;
reg [3:0] remaining;
reg [3:0] counter;
reg [3:0] shift_reg;
reg searching;
reg found_pattern;
reg [1:0] state;

always @(posedge clk) begin
    if (reset) begin
        state <= 2'b00; // IDLE
        searching <= 1'b1;
        found_pattern <= 1'b0;
        shift_reg <= 4'b0000;
        counting <= 1'b0;
        done <= 1'b0;
        counter <= 4'b0000;
        remaining <= 4'b0000;
    end else begin
        case (state)
            2'b00: begin // IDLE
                if (searching) begin
                    if (data) begin // first bit of pattern
                        shift_reg[3] <= 1'b1;
                    end else begin
                        shift_reg[3] <= 1'b0;
                    end
                    shift_reg[2:0] <= shift_reg[3:1];
                    if (shift_reg == 4'b1101) begin
                        state <= 2'b01; // SHIFT_DELAY
                        searching <= 1'b0;
                        found_pattern <= 1'b1;
                    end
                end
            end
            2'b01: begin // SHIFT_DELAY
                if (data) begin // most significant bit of delay
                    delay[3] <= 1'b1;
                end else begin
                    delay[3] <= 1'b0;
                end
                delay[2:0] <= delay[3:1];
                if (counter == 4'b1000) begin
                    state <= 2'b10; // COUNTING
                    counter <= 4'b0000;
                    remaining <= delay + 1;
                end else begin
                    counter <= counter + 1;
                end
            end
            2'b10: begin // COUNTING
                counting <= 1'b1;
                count <= remaining;
                if (counter == 4'b1000) begin
                    remaining <= remaining - 1;
                    counter <= 4'b0000;
                    if (remaining == 4'b0000) begin
                        state <= 2'b11; // DONE
                    end
                end else begin
                    counter <= counter + 1;
                end
            end
            2'b11: begin // DONE
                done <= 1'b1;
                counting <= 1'b0;
                if (ack) begin
                    state <= 2'b00; // IDLE
                    searching <= 1'b1;
                    done <= 1'b0;
                end
            end
        endcase
    end
end

endmodule