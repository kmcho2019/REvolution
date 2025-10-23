module TopModule(
    input clk,
    input reset,
    input [7:0] in,
    output done
);

reg [1:0] state; // 0: waiting for start byte, 1: byte 1 received, 2: byte 2 received
reg done_reg;

always @(posedge clk) begin
    if (reset) begin
        state <= 0;
        done_reg <= 0;
    end else begin
        case (state)
            0: begin // Waiting for start byte
                if (in[3]) begin
                    state <= 1;
                end
            end
            1: begin // Byte 1 received
                state <= 2;
            end
            2: begin // Byte 2 received
                state <= 3;
                done_reg <= 1; // Set done flag
            end
            3: begin // Message received, reset state
                state <= 0;
                done_reg <= 0;
            end
        endcase
    end
end

assign done = (state == 3);

endmodule