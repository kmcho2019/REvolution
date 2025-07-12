module TopModule(
    input  clk,
    input  reset,
    input  [7:0] in,
    output [23:0] out_bytes,
    output done
);

reg [1:0] state; // 2-bit state register (IDLE, BYTE1, BYTE2, DONE)
reg [7:0] byte1, byte2, byte3; // registers to store the received bytes
reg [23:0] out_bytes_reg; // register to store the output bytes
reg done_reg; // register to store the done signal

always @(posedge clk) begin
    if (reset) begin
        state <= 2'b00; // reset state to IDLE
        done_reg <= 1'b0; // reset done signal
        out_bytes_reg <= 24'b0; // reset output bytes
    end else begin
        case (state)
            2'b00: begin // IDLE state
                if (in[3] == 1'b1) begin
                    state <= 2'b01; // transition to BYTE1 state
                    byte1 <= in; // store the received byte
                end
            end
            2'b01: begin // BYTE1 state
                state <= 2'b10; // transition to BYTE2 state
                byte2 <= in; // store the received byte
            end
            2'b10: begin // BYTE2 state
                state <= 2'b11; // transition to DONE state
                byte3 <= in; // store the received byte
            end
            2'b11: begin // DONE state
                done_reg <= 1'b1; // assert done signal
                out_bytes_reg <= {byte1, byte2, byte3}; // output the received bytes
                state <= 2'b00; // transition back to IDLE state
            end
        endcase
    end
end

assign out_bytes = out_bytes_reg;
assign done = done_reg;

endmodule