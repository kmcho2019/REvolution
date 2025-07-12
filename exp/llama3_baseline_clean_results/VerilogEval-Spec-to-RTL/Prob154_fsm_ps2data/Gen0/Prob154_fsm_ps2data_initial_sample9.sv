module TopModule(
    input clk,
    input reset,
    input [7:0] in,
    output [23:0] out_bytes,
    output done
);

reg [1:0] state; // FSM state
reg [23:0] bytes; // Register to store received bytes
reg done_reg; // Register for done signal

always @(posedge clk) begin
    if (reset) begin // Reset
        state <= 2'b00; // IDLE state
        bytes <= 24'd0;
        done_reg <= 1'b0;
    end else begin
        case (state)
            2'b00: begin // IDLE state
                if (in[3] == 1'b1) begin // Check for first byte of message
                    bytes[7:0] <= in; // Store first byte
                    state <= 2'b01; // Move to BYTE1 state
                end
            end
            2'b01: begin // BYTE1 state
                bytes[15:8] <= in; // Store second byte
                state <= 2'b10; // Move to BYTE2 state
            end
            2'b10: begin // BYTE2 state
                bytes[23:16] <= in; // Store third byte
                state <= 2'b00; // Move back to IDLE state
                done_reg <= 1'b1; // Assert done signal
            end
            default: begin
                state <= 2'b00; // Move back to IDLE state
            end
        endcase
    end
end

always @(*) begin
    if (done_reg) begin
        out_bytes = bytes; // Output received message
        done = 1'b1;
    end else begin
        out_bytes = 24'd0; // Output don't care
        done = 1'b0;
    end
end

endmodule