module TopModule(
    input  clk,
    input  reset,
    input  [7:0] in,
    output [23:0] out_bytes,
    output done
);

reg [1:0] state;
reg [23:0] out_bytes_reg;

always @ (posedge clk) begin
    if (reset) begin
        state <= 2'b00; // IDLE state
        out_bytes_reg <= 24'b0;
    end else begin
        case (state)
            2'b00: begin // IDLE state
                if (in[3] == 1'b1) begin
                    out_bytes_reg[7:0] <= in;
                    state <= 2'b01; // BYTE_1 state
                end
            end
            2'b01: begin // BYTE_1 state
                out_bytes_reg[15:8] <= in;
                state <= 2'b10; // BYTE_2 state
            end
            2'b10: begin // BYTE_2 state
                out_bytes_reg[23:16] <= in;
                state <= 2'b00; // IDLE state
            end
        endcase
    end
end

assign done = (state == 2'b10);
assign out_bytes = out_bytes_reg;

endmodule