module TopModule(
    input clk,
    input reset,
    input [7:0] in,
    output done
);

reg [1:0] state; // 0: IDLE, 1: BYTE1, 2: BYTE2
reg done_reg;

always @(posedge clk) begin
    if (reset) begin
        state <= 0; // IDLE
        done_reg <= 0;
    end else begin
        case (state)
            0: begin // IDLE
                if (in[3]) begin
                    state <= 1; // BYTE1
                end
            end
            1: begin // BYTE1
                state <= 2; // BYTE2
            end
            2: begin // BYTE2
                state <= 0; // IDLE
                done_reg <= 1;
            end
        endcase
    end
end

assign done = done_reg;

always @(posedge clk) begin
    if (reset) begin
        done_reg <= 0;
    end else if (done_reg) begin
        done_reg <= 0;
    end
end

endmodule