module TopModule (
    input clk,
    input reset,
    input [7:0] in,
    output done
);

reg [1:0] state; // IDLE, BYTE1, BYTE2, BYTE3
reg done_reg;

always @ (posedge clk) begin
    if (reset) begin
        state <= 2'b00; // IDLE
        done_reg <= 1'b0;
    end else begin
        case (state)
            2'b00: begin // IDLE
                if (in[3]) begin
                    state <= 2'b01; // BYTE1
                end
            end
            2'b01: begin // BYTE1
                state <= 2'b10; // BYTE2
            end
            2'b10: begin // BYTE2
                state <= 2'b11; // BYTE3
            end
            2'b11: begin // BYTE3
                done_reg <= 1'b1;
                state <= 2'b00; // IDLE
            end
        endcase
    end
end

assign done = done_reg;

endmodule