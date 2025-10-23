module TopModule(
    input clk,
    input reset,
    input [7:0] in,
    output [23:0] out_bytes,
    output done
);

reg [1:0] state; // 0: IDLE, 1: BYTE1, 2: BYTE2, 3: BYTE3
reg [23:0] bytes; // store the incoming bytes
reg done_reg; // register the done signal

always @(posedge clk) begin
    if (reset) begin
        state <= 0; // reset to IDLE state
        done_reg <= 0; // reset done signal
        bytes <= 0; // reset bytes register
    end else begin
        case (state)
            0: begin // IDLE state
                if (in[3]) begin // if in[3] = 1, transition to BYTE1 state
                    state <= 1;
                    bytes[23:16] <= in; // store the first byte
                end
            end
            1: begin // BYTE1 state
                state <= 2; // transition to BYTE2 state
                bytes[15:8] <= in; // store the second byte
            end
            2: begin // BYTE2 state
                state <= 3; // transition to BYTE3 state
                bytes[7:0] <= in; // store the third byte
            end
            3: begin // BYTE3 state
                state <= 0; // transition back to IDLE state
                done_reg <= 1; // assert done signal
            end
        endcase
        if (done_reg) begin
            done_reg <= 0; // de-assert done signal in the next cycle
        end
    end
end

assign done = done_reg; // assign the done signal
assign out_bytes = bytes; // assign the output bytes

endmodule