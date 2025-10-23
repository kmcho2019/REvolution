module TopModule(
    input clk,
    input reset,
    input data,
    output [3:0] count,
    output counting,
    output done,
    input ack
);

reg [3:0] state; // 0: IDLE, 1: SHIFT_DELAY, 2: COUNTING, 3: DONE
reg [3:0] delay; // delay bits
reg [3:0] remaining; // remaining time
reg [3:0] count_out; // output count
reg [3:0] pattern_reg; // register to store the input pattern
reg searching; // flag to indicate if we are searching for the pattern

always @(posedge clk or posedge reset) begin
    if (reset) begin
        state <= 0; // IDLE
        searching <= 1'b1;
        pattern_reg <= 4'b0000;
        count_out <= 4'b0000;
        done <= 1'b0;
        counting <= 1'b0;
    end else begin
        case (state)
            0: begin // IDLE
                if (searching) begin
                    pattern_reg <= {pattern_reg[2:0], data};
                    if (pattern_reg == 4'b1101) begin
                        state <= 1; // SHIFT_DELAY
                        searching <= 1'b0;
                        pattern_reg <= 4'b0000;
                    end
                end
            end
            1: begin // SHIFT_DELAY
                pattern_reg <= {pattern_reg[2:0], data};
                if (pattern_reg == 4'b0000) begin
                    delay <= pattern_reg;
                    state <= 2; // COUNTING
                    remaining <= delay + 1;
                    counting <= 1'b1;
                    count_out <= delay;
                end else begin
                    pattern_reg <= {pattern_reg[2:0], data};
                end
            end
            2: begin // COUNTING
                if (remaining > 1) begin
                    if (count_out > 0) begin
                        count_out <= count_out - 1;
                    end else begin
                        remaining <= remaining - 1;
                        count_out <= remaining;
                    end
                end else if (remaining == 1) begin
                    count_out <= 0;
                    remaining <= remaining - 1;
                    state <= 3; // DONE
                    counting <= 1'b0;
                    done <= 1'b1;
                end
            end
            3: begin // DONE
                if (ack) begin
                    state <= 0; // IDLE
                    done <= 1'b0;
                    searching <= 1'b1;
                end
            end
        endcase
    end
end

assign count = (state == 2) ? count_out : 4'bxxxx;

endmodule