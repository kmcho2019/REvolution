module TopModule(
    input clk,
    input reset,
    input [7:0] in,
    output [23:0] out_bytes,
    output done
);

reg [1:0] state; // Idle (0), Byte1 (1), Byte2 (2), Byte3 (3)
reg [7:0] byte1, byte2, byte3;
reg [23:0] out_bytes_reg;

assign out_bytes = out_bytes_reg;
assign done = (state == 2'b11);

always @(posedge clk) begin
    if (reset) begin
        state <= 2'b00;
        out_bytes_reg <= 24'b0;
    end else begin
        case (state)
            2'b00: begin // Idle
                if (in[3] == 1'b1) begin
                    byte1 <= in;
                    state <= 2'b01;
                end
            end
            2'b01: begin // Byte1
                byte2 <= in;
                state <= 2'b10;
            end
            2'b10: begin // Byte2
                byte3 <= in;
                state <= 2'b11;
            end
            2'b11: begin // Done
                out_bytes_reg <= {byte1, byte2, byte3};
                state <= 2'b00;
            end
        endcase
    end
end

endmodule