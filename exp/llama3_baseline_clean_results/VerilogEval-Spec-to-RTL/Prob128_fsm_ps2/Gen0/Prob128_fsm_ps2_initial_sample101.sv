module TopModule(
    input  clk,
    input  reset,
    input  [7:0] in,
    output done
);

reg [1:0] state; // 0 - IDLE, 1 - BYTE1, 2 - BYTE2
reg done_reg;

always @ (posedge clk) begin
    if (reset) begin
        state <= 0; // IDLE
        done_reg <= 0;
    end else begin
        case (state)
            0: begin // IDLE
                if (in[3]) begin
                    state <= 1; // Transition to BYTE1
                end
            end
            1: begin // BYTE1
                state <= 2; // Transition to BYTE2
            end
            2: begin // BYTE2
                done_reg <= 1; // Signal done
                state <= 0; // Transition back to IDLE
            end
        endcase
    end
end

assign done = done_reg;

always @ (posedge clk) begin
    if (~reset) begin
        done_reg <= 0; // Reset done signal in the next cycle
    end
end

endmodule