module TopModule(
    input  clk,
    input  reset,
    input  [7:0] in,
    output [23:0] out_bytes,
    output done
);

reg [23:0] out_bytes_reg;
reg done_reg;
reg [1:0] state;

always @(*) begin
    case(state)
        2'b00: begin // IDLE
            if (in[3] == 1'b1) begin
                state = 2'b01; // transition to BYTE_1
                out_bytes_reg = {in, 16'd0};
            end else begin
                state = 2'b00; // stay in IDLE
                out_bytes_reg = 24'd0;
            end
        end
        2'b01: begin // BYTE_1
            state = 2'b10; // transition to BYTE_2
            out_bytes_reg = {in, out_bytes_reg[15:8], 8'd0};
        end
        2'b10: begin // BYTE_2
            state = 2'b11; // transition to BYTE_3
            out_bytes_reg = {out_bytes_reg[23:16], in, out_bytes_reg[7:0]};
        end
        2'b11: begin // BYTE_3
            state = 2'b00; // transition back to IDLE
            out_bytes_reg = {out_bytes_reg[23:16], out_bytes_reg[15:8], in};
            done_reg = 1'b1;
        end
    endcase
end

always @(posedge clk) begin
    if (reset) begin
        state <= 2'b00;
        done_reg <= 1'b0;
        out_bytes_reg <= 24'd0;
    end else begin
        done_reg <= (state == 2'b11) ? 1'b1 : 1'b0;
        out_bytes <= out_bytes_reg;
    end
end

assign done = done_reg;

endmodule