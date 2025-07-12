module TopModule(
    input clk,
    input reset,
    input [7:0] in,
    output reg done
);

reg [1:0] state; // 0: IDLE, 1: BYTE1, 2: BYTE2, 3: BYTE3

always @ (posedge clk) begin
    if (reset) begin
        state <= 0;
        done <= 0;
    end else begin
        case (state)
            0: begin // IDLE
                if (in[3]) begin
                    state <= 1;
                end
            end
            1: begin // BYTE1
                state <= 2;
            end
            2: begin // BYTE2
                state <= 3;
            end
            3: begin // BYTE3
                done <= 1;
                state <= 0;
            end
            default: state <= 0;
        endcase
        if (state != 3) begin
            done <= 0;
        end
    end
end

endmodule