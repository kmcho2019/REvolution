module TopModule (
    input clk,
    input reset,
    input [7:0] in,
    output done
);

reg [1:0] state; // IDLE (0), BYTE1 (1), BYTE2 (2), BYTE3 (3)
reg [7:0] byte1, byte2, byte3; // bytes of the message

always @(posedge clk) begin
    if (reset) begin // reset
        state <= 2'b00; // IDLE state
        done <= 1'b0;
    end else begin
        case (state)
            2'b00: begin // IDLE
                if (in[3] == 1'b1) begin
                    state <= 2'b01; // transition to BYTE1 state
                    byte1 <= in;
                end else begin
                    state <= 2'b00; // stay in IDLE state
                end
            end
            2'b01: begin // BYTE1
                state <= 2'b10; // transition to BYTE2 state
                byte2 <= in;
            end
            2'b10: begin // BYTE2
                state <= 2'b11; // transition to BYTE3 state
                byte3 <= in;
            end
            2'b11: begin // BYTE3
                done <= 1'b1; // signal done
                state <= 2'b00; // return to IDLE state
            end
            default: begin
                state <= 2'b00; // return to IDLE state
            end
        endcase
    end
end

always @(posedge clk) begin
    if (state == 2'b11) begin
        done <= 1'b1; // hold done signal high for one cycle
    end else begin
        done <= 1'b0; // reset done signal
    end
end

endmodule