module TopModule(
    input clk,
    input reset,
    input [7:0] in,
    output [23:0] out_bytes,
    output done
);

reg [23:0] out_bytes_reg;
reg [1:0] byte_count;
reg [1:0] state; // 2'b00: IDLE, 2'b01: RECV_BYTES, 2'b10: DONE

assign out_bytes = out_bytes_reg;
assign done = (state == 2'b10);

always @(posedge clk) begin
    if (reset) begin
        out_bytes_reg <= 24'd0;
        byte_count <= 2'd0;
        state <= 2'b00;
    end else begin
        case (state)
            2'b00: begin // IDLE
                if (in[3] == 1'b1) begin
                    out_bytes_reg <= {in, 16'd0};
                    byte_count <= 2'd1;
                    state <= 2'b01;
                end
            end
            2'b01: begin // RECV_BYTES
                case (byte_count)
                    2'd1: begin
                        out_bytes_reg <= {out_bytes_reg[23:8], in, 8'd0};
                        byte_count <= 2'd2;
                    end
                    2'd2: begin
                        out_bytes_reg <= {out_bytes_reg[23:8], in};
                        byte_count <= 2'd0;
                        state <= 2'b10;
                    end
                endcase
            end
            2'b10: begin // DONE
                state <= 2'b00;
            end
        endcase
    end
end

endmodule