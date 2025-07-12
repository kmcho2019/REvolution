module TopModule(
    input clk,
    input reset,
    input [7:0] in,
    output [23:0] out_bytes,
    output done
);

reg [1:0] state;
reg [7:0] byte1, byte2, byte3;

always @(posedge clk) begin
    if (reset) begin
        state <= 2'b00; // Reset to IDLE state
        byte1 <= 8'b0;
        byte2 <= 8'b0;
        byte3 <= 8'b0;
    end else begin
        case (state)
            2'b00: // IDLE
                if (in[3]) begin
                    state <= 2'b01; // Transition to BYTE1
                    byte1 <= in;
                end
            2'b01: // BYTE1
                begin
                    state <= 2'b10; // Transition to BYTE2
                    byte2 <= in;
                end
            2'b10: // BYTE2
                begin
                    state <= 2'b11; // Transition to BYTE3
                    byte3 <= in;
                end
            2'b11: // BYTE3
                state <= 2'b00; // Transition back to IDLE
        endcase
    end
end

assign out_bytes = {byte1, byte2, byte3};
assign done = (state == 2'b11); // Assert done in BYTE3 state

endmodule