module TopModule (
    input clk,
    input reset,
    input [7:0] in,
    output [23:0] out_bytes,
    output done
);

reg [1:0] state; // Two-state state machine
reg [1:0] byte_count;
reg [23:0] out_bytes_reg;

always @(posedge clk or posedge reset) begin
    if (reset) begin
        state <= 2'b00; // IDLE state
        out_bytes_reg <= 24'b0;
        byte_count <= 2'b0;
    end else begin
        case (state)
            2'b00: begin // IDLE state
                if (in[3] == 1'b1) begin
                    out_bytes_reg[23:16] <= in; // Store first byte
                    state <= 2'b01; // Transition to RECEIVE state
                    byte_count <= 2'b1;
                end
            end
            2'b01: begin // RECEIVE state
                if (byte_count == 2'b1) begin
                    out_bytes_reg[15:8] <= in; // Store second byte
                    byte_count <= 2'b10;
                end else if (byte_count == 2'b10) begin
                    out_bytes_reg[7:0] <= in; // Store third byte
                    state <= 2'b00; // Transition back to IDLE state
                end
            end
        endcase
    end
end

assign out_bytes = (state == 2'b00 && byte_count == 2'b10) ? out_bytes_reg : 24'b0;
assign done = (state == 2'b00 && byte_count == 2'b10);

endmodule