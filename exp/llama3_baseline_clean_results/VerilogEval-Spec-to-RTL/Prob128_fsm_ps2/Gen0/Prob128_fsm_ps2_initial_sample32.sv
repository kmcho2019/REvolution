module TopModule(
    input clk,
    input reset,
    input [7:0] in,
    output reg done
);

reg [1:0] state; // 0: IDLE, 1: BYTE1, 2: BYTE2, 3: BYTE3
reg [7:0] byte1, byte2, byte3; // store the bytes of the message

always @(posedge clk) begin
    if (reset) begin
        state <= 0; // reset to IDLE state
        done <= 0; // clear done signal
    end else begin
        case (state)
            0: begin // IDLE state
                if (in[3] == 1) begin
                    byte1 <= in; // store the first byte
                    state <= 1; // transition to BYTE1 state
                end
            end
            1: begin // BYTE1 state
                byte2 <= in; // store the second byte
                state <= 2; // transition to BYTE2 state
            end
            2: begin // BYTE2 state
                byte3 <= in; // store the third byte
                state <= 3; // transition to BYTE3 state
            end
            3: begin // BYTE3 state
                done <= 1; // signal the receipt of a message
                if (in[3] == 1) begin
                    byte1 <= in; // store the new first byte
                    state <= 1; // transition to BYTE1 state
                end else begin
                    state <= 0; // transition to IDLE state
                end
            end
            default: state <= 0; // default to IDLE state
        endcase
        if (state != 3) begin
            done <= 0; // clear done signal
        end
    end
end

endmodule