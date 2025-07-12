module TopModule(
    input clk,
    input reset,
    input [7:0] in,
    output done
);

reg [1:0] state; // 0: idle, 1: byte1, 2: byte2, 3: byte3 (don't care for this state)
reg done_reg;

always @(posedge clk) begin
    if (reset) begin
        state <= 0;
        done_reg <= 0;
    end else begin
        case (state)
            0: begin // idle
                if (in[3]) begin
                    state <= 1;
                end else begin
                    state <= 0;
                end
                done_reg <= 0;
            end
            1: begin // byte1
                state <= 2;
                done_reg <= 0;
            end
            2: begin // byte2
                state <= 3; // don't care for this state, just need to advance
                done_reg <= 0;
            end
            3: begin // done
                state <= 0; // back to idle
                done_reg <= 1;
            end
        endcase
    end
end

assign done = done_reg;

endmodule