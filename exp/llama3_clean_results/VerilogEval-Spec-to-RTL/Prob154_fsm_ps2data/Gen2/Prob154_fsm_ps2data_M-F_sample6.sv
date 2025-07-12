module TopModule(
    input clk,
    input reset,
    input [7:0] in,
    output [23:0] out_bytes,
    output done
);

reg [1:0] state;
reg [23:0] out_bytes_reg;
reg done_reg;

always @(posedge clk) begin
    if (reset) begin
        state <= 2'b00;
        out_bytes_reg <= 24'b0;
        done_reg <= 1'b0;
    end else begin
        case (state)
            2'b00: begin // IDLE
                if (in[3] == 1'b1) begin
                    out_bytes_reg <= {in, 16'b0};
                    state <= 2'b01;
                end
            end
            2'b01: begin // RECEIVING BYTE 2
                out_bytes_reg <= {out_bytes_reg[15:8], in, 8'b0};
                state <= 2'b10;
            end
            2'b10: begin // RECEIVING BYTE 3
                out_bytes_reg <= {in, out_bytes_reg[15:8], out_bytes_reg[7:0]};
                done_reg <= 1'b1;
                state <= 2'b00;
            end
        endcase
    end
end

assign out_bytes = out_bytes_reg;
assign done = done_reg;

endmodule