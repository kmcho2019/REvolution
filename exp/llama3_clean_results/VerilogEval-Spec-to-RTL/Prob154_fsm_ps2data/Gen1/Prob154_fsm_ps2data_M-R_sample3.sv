module TopModule (
    input clk,
    input reset,
    input [7:0] in,
    output [23:0] out_bytes,
    output done
);

reg [2:0] state; // One-hot encoding
reg [23:0] out_bytes_reg;
reg done_reg;

always @(posedge clk or posedge reset) begin
    if (reset) begin
        state <= 1'b1; // IDLE state
        out_bytes_reg <= 24'b0;
        done_reg <= 1'b0;
    end else begin
        case (1'b1) // One-hot decoding
            state[0]: begin // IDLE state
                if (in[3] == 1'b1) begin
                    out_bytes_reg[23:16] <= in; // Store first byte
                    state <= 4'b10; // Transition to BYTE1 state
                end
            end
            state[1]: begin // BYTE1 state
                out_bytes_reg[15:8] <= in; // Store second byte
                state <= 4'b100; // Transition to BYTE2 state
            end
            state[2]: begin // BYTE2 state
                out_bytes_reg[7:0] <= in; // Store third byte
                state <= 4'b1000; // Transition to BYTE3 state
            end
            state[3]: begin // BYTE3 state
                done_reg <= 1'b1; // Signal done
                state <= 1'b1; // Transition back to IDLE state
            end
            default: begin
                state <= 1'b1; // Default to IDLE state
            end
        endcase
        if (state!= 4'b1000) begin // Not in BYTE3 state
            done_reg <= 1'b0; // Clear done signal
        end
    end
end

assign out_bytes = out_bytes_reg;
assign done = done_reg;

endmodule