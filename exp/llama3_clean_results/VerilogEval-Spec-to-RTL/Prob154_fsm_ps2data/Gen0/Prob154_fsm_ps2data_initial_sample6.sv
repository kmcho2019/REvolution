module TopModule (
    input clk,
    input reset,
    input [7:0] in,
    output [23:0] out_bytes,
    output done
);

reg [1:0] state;
reg [23:0] out_bytes_reg;
reg done_reg;

always @(posedge clk or posedge reset) begin
    if (reset) begin
        state <= 2'b00; // IDLE state
        out_bytes_reg <= 24'b0;
        done_reg <= 1'b0;
    end else begin
        case (state)
            2'b00: begin // IDLE state
                if (in[3] == 1'b1) begin
                    out_bytes_reg[23:16] <= in; // Store first byte
                    state <= 2'b01; // Transition to BYTE1 state
                end else begin
                    state <= 2'b00; // Stay in IDLE state
                end
            end
            2'b01: begin // BYTE1 state
                out_bytes_reg[15:8] <= in; // Store second byte
                state <= 2'b10; // Transition to BYTE2 state
            end
            2'b10: begin // BYTE2 state
                out_bytes_reg[7:0] <= in; // Store third byte
                state <= 2'b11; // Transition to BYTE3 state
            end
            2'b11: begin // BYTE3 state
                done_reg <= 1'b1; // Signal done
                state <= 2'b00; // Transition back to IDLE state
            end
            default: begin
                state <= 2'b00; // Default to IDLE state
            end
        endcase
        if (state != 2'b11) begin // Not in BYTE3 state
            done_reg <= 1'b0; // Clear done signal
        end
    end
end

assign out_bytes = out_bytes_reg;
assign done = done_reg;

endmodule