module TopModule(
    input clk,
    input reset,
    input [7:0] in,
    output reg done
);

reg [1:0] state; // 0: IDLE, 1: BYTE1, 2: BYTE2, 3: BYTE3
reg [7:0] byte1, byte2, byte3; // store the bytes of the message

always @ (posedge clk) begin
    if (reset) begin
        state <= 0;
        done <= 0;
    end else begin
        case (state)
            0: begin // IDLE state
                if (in[3]) begin
                    byte1 <= in;
                    state <= 1;
                end
            end
            1: begin // BYTE1 state
                byte2 <= in;
                state <= 2;
            end
            2: begin // BYTE2 state
                byte3 <= in;
                state <= 0; // back to IDLE after receiving the third byte
                done <= 1; // assert done signal
            end
            default: state <= 0;
        endcase
    end
end

always @ (posedge clk) begin
    if (~reset && (state == 0 && done)) begin
        done <= 0; // deassert done signal
    end
end

endmodule