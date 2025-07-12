module TopModule(
    input clk,
    input reset,
    input [7:0] in,
    output reg done = 1'b0
);

reg [1:0] state = 2'b00; // 00: IDLE, 01: BYTE1, 10: BYTE2

always @ (posedge clk) begin
    if (reset) begin
        state <= 2'b00;
        done <= 1'b0;
    end else begin
        case (state)
            2'b00: begin // IDLE
                if (in[3]) begin
                    state <= 2'b01;
                end
                done <= 1'b0;
            end
            2'b01: begin // BYTE1
                state <= 2'b10;
                done <= 1'b0;
            end
            2'b10: begin // BYTE2
                state <= 2'b00;
                done <= 1'b1;
            end
        endcase
    end
end

endmodule