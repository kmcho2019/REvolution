module TopModule(
    input clk,
    input reset,
    input [7:0] in,
    output done
);

reg [1:0] state; // 0 - IDLE, 1 - BYTE1, 2 - BYTE2, 3 - BYTE3
reg [7:0] byte1, byte2, byte3;
reg done_reg;

always @(posedge clk) begin
    if (reset) begin
        state <= 0;
        done_reg <= 0;
    end else begin
        case (state)
            0: begin // IDLE
                if (in[3]) begin
                    byte1 <= in;
                    state <= 1;
                end
            end
            1: begin // BYTE1
                byte2 <= in;
                state <= 2;
            end
            2: begin // BYTE2
                byte3 <= in;
                state <= 3;
            end
            3: begin // BYTE3
                done_reg <= 1;
                state <= 0;
            end
        endcase
    end
end

always @(posedge clk) begin
    if (!reset) begin
        done <= done_reg;
    end else begin
        done <= 0;
    end
end

endmodule