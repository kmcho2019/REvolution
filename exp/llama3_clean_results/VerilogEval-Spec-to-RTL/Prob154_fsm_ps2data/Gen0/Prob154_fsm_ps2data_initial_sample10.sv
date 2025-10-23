module TopModule(
    input clk,
    input reset,
    input [7:0] in,
    output [23:0] out_bytes,
    output done
);

reg [1:0] state;
reg [7:0] byte1, byte2;
reg [23:0] out_bytes_reg;

assign out_bytes = out_bytes_reg;
assign done = (state == 2'b10);

always @(posedge clk) begin
    if (reset) begin
        state <= 2'b00;
        byte1 <= 8'd0;
        byte2 <= 8'd0;
        out_bytes_reg <= 24'd0;
    end else begin
        case (state)
            2'b00: begin // IDLE state
                if (in[3] == 1'b1) begin
                    byte1 <= in;
                    state <= 2'b01;
                end
            end
            2'b01: begin // RECV_BYTE1 state
                byte2 <= in;
                state <= 2'b10;
            end
            2'b10: begin // RECV_BYTE2 state
                out_bytes_reg <= {byte1, byte2, in};
                state <= 2'b00;
            end
        endcase
    end
end

endmodule