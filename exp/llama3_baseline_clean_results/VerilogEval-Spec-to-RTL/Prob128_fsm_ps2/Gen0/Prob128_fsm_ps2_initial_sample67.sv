module TopModule(
    input clk,
    input reset,
    input [7:0] in,
    output reg done
);

reg [1:0] state; // 0: Searching for first byte, 1: Received first byte, 2: Received second byte

always @(posedge clk) begin
    if (reset) begin
        state <= 0;
        done <= 0;
    end else begin
        case (state)
            0: begin // Searching for first byte
                if (in[3] == 1'b1) begin
                    state <= 1;
                end
            end
            1: begin // Received first byte
                state <= 2;
            end
            2: begin // Received second byte
                state <= 0;
                done <= 1'b1;
            end
        endcase
    end
end

endmodule