module TopModule(
    input clk,
    input reset,
    input [7:0] in,
    output reg done
);

reg [1:0] state; // 0: Idle, 1: Byte1, 2: Byte2, 3: Byte3
always @(posedge clk) begin
    if (reset) begin
        state <= 0;
        done <= 0;
    end else begin
        case (state)
            0: begin // Idle
                if (in[3]) begin
                    state <= 1;
                end else begin
                    state <= 0;
                end
                done <= 0;
            end
            1: begin // Byte1
                state <= 2;
                done <= 0;
            end
            2: begin // Byte2
                state <= 3;
                done <= 0;
            end
            3: begin // Byte3
                state <= 0;
                done <= 1;
            end
        endcase
    end
end

endmodule