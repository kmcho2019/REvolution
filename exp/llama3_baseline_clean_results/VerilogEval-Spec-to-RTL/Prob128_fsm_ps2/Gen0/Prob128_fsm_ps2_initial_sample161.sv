module TopModule(
    input clk,
    input reset,
    input [7:0] in,
    output reg done
);

reg [1:0] state; // 2 bits for 4 states
reg [7:0] byte1, byte2; // registers to store bytes

always @(posedge clk) begin
    if (reset) begin
        state <= 2'b00; // IDLE state
        done <= 0;
    end else begin
        case (state)
            2'b00: begin // IDLE state
                if (in[3] == 1'b1) begin
                    state <= 2'b01; // transition to BYTE1 state
                    byte1 <= in;
                end else begin
                    state <= 2'b00; // stay in IDLE state
                end
                done <= 0;
            end
            2'b01: begin // BYTE1 state
                state <= 2'b10; // transition to BYTE2 state
                byte2 <= in;
                done <= 0;
            end
            2'b10: begin // BYTE2 state
                state <= 2'b11; // transition to BYTE3 state
                done <= 0;
            end
            2'b11: begin // BYTE3 state
                state <= 2'b00; // transition back to IDLE state
                done <= 1; // assert done signal
            end
        endcase
    end
end

endmodule