module TopModule(
    input clk,
    input reset,
    input [7:0] in,
    output done
);

reg [1:0] state; // 0: IDLE, 1: BYTE1, 2: BYTE2, 3: BYTE3
reg done_reg;

always @(posedge clk) begin
    if (reset) begin
        state <= 0;
        done_reg <= 0;
    end else begin
        case (state)
            0: begin // IDLE
                if (in[3] == 1'b1) begin
                    state <= 1; // Transition to BYTE1
                end
            end
            1: begin // BYTE1
                state <= 2; // Transition to BYTE2
            end
            2: begin // BYTE2
                state <= 3; // Transition to BYTE3
            end
            3: begin // BYTE3
                done_reg <= 1'b1; // Set done for one cycle
                state <= 0; // Reset to IDLE
            end
            default: state <= 0;
        endcase
        
        // Reset done_reg for the next cycle
        if (state != 3) begin
            done_reg <= 1'b0;
        end
    end
end

assign done = done_reg;

endmodule