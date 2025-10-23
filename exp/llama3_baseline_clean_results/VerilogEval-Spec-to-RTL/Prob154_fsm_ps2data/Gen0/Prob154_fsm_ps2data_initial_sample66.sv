module TopModule(
    input clk,
    input reset,
    input [7:0] in,
    output [23:0] out_bytes,
    output done
);

reg [1:0] state; // IDLE = 2'b00, BYTE1 = 2'b01, BYTE2 = 2'b10, BYTE3 = 2'b11
reg [7:0] byte1, byte2, byte3;

always @(posedge clk) begin
    if (reset) begin
        state <= 2'b00;
        byte1 <= 8'b0;
        byte2 <= 8'b0;
        byte3 <= 8'b0;
    end else begin
        case (state)
            2'b00: begin // IDLE
                if (in[3]) begin
                    byte1 <= in;
                    state <= 2'b01;
                end
            end
            2'b01: begin // BYTE1
                byte2 <= in;
                state <= 2'b10;
            end
            2'b10: begin // BYTE2
                byte3 <= in;
                state <= 2'b11;
            end
            2'b11: begin // BYTE3
                state <= 2'b00;
            end
        endcase
    end
end

assign out_bytes = {byte1, byte2, byte3};
assign done = (state == 2'b11);

endmodule