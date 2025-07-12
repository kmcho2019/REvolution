module TopModule (
    input clk,
    input reset,
    input [7:0] in,
    output [23:0] out_bytes,
    output done
);

reg [1:0] state; // IDLE, BYTE1, BYTE2, BYTE3
reg [7:0] byte1, byte2, byte3;
reg [23:0] out_bytes_reg;
reg done_reg;

always @(posedge clk) begin
    if (reset) begin
        state <= 2'b00; // IDLE
        out_bytes_reg <= 24'd0;
        done_reg <= 1'b0;
    end else begin
        case (state)
            2'b00: begin // IDLE
                if (in[3] == 1'b1) begin
                    byte1 <= in;
                    state <= 2'b01; // BYTE1
                end
            end
            2'b01: begin // BYTE1
                byte2 <= in;
                state <= 2'b10; // BYTE2
            end
            2'b10: begin // BYTE2
                byte3 <= in;
                state <= 2'b11; // BYTE3
            end
            2'b11: begin // BYTE3
                out_bytes_reg <= {byte1, byte2, byte3};
                done_reg <= 1'b1;
                state <= 2'b00; // IDLE
            end
        endcase
    end
end

assign out_bytes = out_bytes_reg;
assign done = done_reg && (state == 2'b11);

endmodule