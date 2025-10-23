module TopModule (
    input  clk,
    input  reset,
    input  [7:0] in,
    output done
);

reg [1:0] state; // 0: idle, 1: byte1, 2: byte2, 3: byte3
reg done_reg;

always @(posedge clk) begin
    if (reset) begin
        state <= 0;
        done_reg <= 0;
    end else begin
        case (state)
            0: begin // idle
                if (in[3]) begin
                    state <= 1; // transition to byte1
                end else begin
                    state <= 0; // stay in idle
                end
            end
            1: begin // byte1
                state <= 2; // transition to byte2
            end
            2: begin // byte2
                state <= 3; // transition to byte3
            end
            3: begin // byte3
                state <= 0; // transition back to idle
                done_reg <= 1; // signal done
            end
        endcase
    end
end

always @(posedge clk) begin
    if (reset) begin
        done <= 0;
    end else begin
        done <= done_reg;
        done_reg <= 0; // clear done_reg after one cycle
    end
end

endmodule