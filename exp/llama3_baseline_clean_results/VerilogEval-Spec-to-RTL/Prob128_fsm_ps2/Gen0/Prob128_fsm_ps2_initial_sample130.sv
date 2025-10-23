module TopModule(
    input clk,
    input reset,
    input [7:0] in,
    output reg done
);

reg [1:0] state; // 0: IDLE, 1: MESSAGE-byte1, 2: MESSAGE-byte2, 3: MESSAGE-byte3

always @(posedge clk) begin
    if (reset) begin
        state <= 0;
        done <= 0;
    end else begin
        case (state)
            0: begin // IDLE
                if (in[3]) begin
                    state <= 1; // transition to MESSAGE-byte1
                end
            end
            1: begin // MESSAGE-byte1
                state <= 2; // transition to MESSAGE-byte2
            end
            2: begin // MESSAGE-byte2
                state <= 3; // transition to MESSAGE-byte3
            end
            3: begin // MESSAGE-byte3
                done <= 1; // assert done signal
                state <= 0; // transition back to IDLE
            end
            default: state <= 0;
        endcase
        if (state != 3) begin // de-assert done signal when not in MESSAGE-byte3 state
            done <= 0;
        end
    end
end

endmodule