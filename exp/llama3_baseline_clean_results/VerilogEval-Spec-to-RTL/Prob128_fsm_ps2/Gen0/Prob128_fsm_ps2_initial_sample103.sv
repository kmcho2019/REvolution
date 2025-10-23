module TopModule(
    input clk,
    input reset,
    input [7:0] in,
    output done
);

reg [1:0] state; // 0: IDLE, 1: BYTE_1, 2: BYTE_2, 3: BYTE_3
reg done_reg;

always @(posedge clk) begin
    if (reset) begin
        state <= 0;
        done_reg <= 0;
    end else begin
        case (state)
            0: begin // IDLE
                if (in[3]) begin
                    state <= 1;
                end else begin
                    state <= 0;
                end
                done_reg <= 0;
            end
            1: begin // BYTE_1
                state <= 2;
                done_reg <= 0;
            end
            2: begin // BYTE_2
                state <= 3;
                done_reg <= 0;
            end
            3: begin // BYTE_3
                state <= 0;
                done_reg <= 1;
            end
        endcase
    end
end

assign done = done_reg;

endmodule