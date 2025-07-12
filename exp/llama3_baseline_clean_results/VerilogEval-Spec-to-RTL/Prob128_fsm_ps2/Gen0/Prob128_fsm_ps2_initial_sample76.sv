module TopModule(
    input clk,
    input reset,
    input [7:0] in,
    output reg done
);

reg [1:0] state; // 0: IDLE, 1: BYTE1, 2: BYTE2
reg [7:0] byte1, byte2;

always @(posedge clk) begin
    if (reset) begin
        state <= 0; // IDLE
        done <= 0;
    end
    else begin
        case (state)
            0: begin // IDLE
                if (in[3]) begin
                    byte1 <= in;
                    state <= 1; // BYTE1
                end
                done <= 0;
            end
            1: begin // BYTE1
                byte2 <= in;
                state <= 2; // BYTE2
                done <= 0;
            end
            2: begin // BYTE2
                state <= 0; // IDLE
                done <= 1; // Signal done
            end
        endcase
    end
end

endmodule