module TopModule (
    input clk,
    input reset,
    input [7:0] in,
    output [23:0] out_bytes,
    output done
);

reg [1:0] state; // 2-bit counter for states
reg [23:0] out_bytes_reg; // 24-bit register for out_bytes
reg done_reg; // 1-bit signal for done
reg [1:0] byte_count; // 2-bit counter for bytes

always @(posedge clk or posedge reset) begin
    if (reset) begin
        state <= 2'b00; // Reset state to IDLE
        out_bytes_reg <= 24'b0; // Reset out_bytes to 0
        done_reg <= 1'b0; // Reset done to 0
        byte_count <= 2'b00; // Reset byte count to 0
    end else begin
        case (state)
            2'b00: begin // IDLE state
                if (in[3] == 1'b1) begin
                    out_bytes_reg[23:16] <= in; // Store first byte
                    state <= 2'b01; // Transition to BYTE1 state
                    byte_count <= 2'b01; // Increment byte count
                end
            end
            2'b01: begin // BYTE1 state
                out_bytes_reg[15:8] <= in; // Store second byte
                byte_count <= byte_count + 1; // Increment byte count
                if (byte_count == 2'b10) begin
                    state <= 2'b10; // Transition to BYTE2 state
                end
            end
            2'b10: begin // BYTE2 state
                out_bytes_reg[7:0] <= in; // Store third byte
                done_reg <= 1'b1; // Assert done signal
                state <= 2'b00; // Transition back to IDLE state
                byte_count <= 2'b00; // Reset byte count
            end
            default: begin
                state <= 2'b00; // Default to IDLE state
            end
        endcase
    end
end

assign out_bytes = (done_reg) ? out_bytes_reg : 24'b0;
assign done = done_reg;

endmodule