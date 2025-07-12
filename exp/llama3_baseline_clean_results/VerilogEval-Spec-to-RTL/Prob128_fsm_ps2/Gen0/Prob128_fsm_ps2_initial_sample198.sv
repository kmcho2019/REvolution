module TopModule(
    input clk,
    input reset,
    input [7:0] in,
    output done
);

reg [1:0] state; // 0: IDLE, 1: BYTE1, 2: BYTE2, 3: BYTE3 (but only 3 values are used)
reg done_reg;

always @(posedge clk) begin
    if (reset) begin
        state <= 0;
        done_reg <= 0;
    end
    else begin
        case (state)
            0: begin // IDLE
                if (in[3] == 1) begin
                    state <= 1; // transition to BYTE1
                end
                else begin
                    state <= 0; // stay in IDLE
                end
            end
            1: begin // BYTE1
                state <= 2; // transition to BYTE2
            end
            2: begin // BYTE2
                state <= 3; // transition to BYTE3
            end
            default: begin // BYTE3
                done_reg <= 1; // signal done
                state <= 0; // transition back to IDLE
            end
        endcase
    end
end

assign done = (state == 3 && ~reset) || done_reg;

always @(posedge clk) begin
    if (~reset) begin
        done_reg <= 0;
    end
end

endmodule