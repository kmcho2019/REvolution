module TopModule(
    input clk,
    input reset,
    input [7:0] in,
    output done
);

reg [1:0] state;
reg [7:0] byte1, byte2, byte3;

always @(posedge clk) begin
    if (reset) begin
        state <= 2'b00; // IDLE state
        done <= 0;
    end else begin
        case (state)
            2'b00: begin // IDLE state
                if (in[3]) begin
                    byte1 <= in;
                    state <= 2'b01; // BYTE1 state
                end
            end
            2'b01: begin // BYTE1 state
                byte2 <= in;
                state <= 2'b10; // BYTE2 state
            end
            2'b10: begin // BYTE2 state
                byte3 <= in;
                state <= 2'b00; // IDLE state after receiving the third byte
                done <= 1;
            end
            default: begin
                state <= 2'b00; // IDLE state
                done <= 0;
            end
        endcase
    end
end

endmodule