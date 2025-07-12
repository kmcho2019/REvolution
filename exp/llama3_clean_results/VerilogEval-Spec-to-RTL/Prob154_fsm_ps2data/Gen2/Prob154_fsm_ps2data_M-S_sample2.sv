module TopModule(
    input clk,
    input reset,
    input [7:0] in,
    output [23:0] out_bytes,
    output done
);

reg [23:0] out_bytes_reg;
reg [1:0] byte_count;
reg state;

assign out_bytes = out_bytes_reg;
assign done = state && (byte_count == 2'b10);

always @(posedge clk) begin
    if (reset) begin
        out_bytes_reg <= 24'd0;
        byte_count <= 2'd0;
        state <= 1'b0;
    end else begin
        if (!state) begin
            if (in[3] == 1'b1) begin
                out_bytes_reg <= {in, 16'd0};
                byte_count <= 2'd1;
                state <= 1'b1;
            end
        end else begin
            case (byte_count)
                2'd1: begin
                    out_bytes_reg <= {out_bytes_reg[23:8], in};
                    byte_count <= 2'd2;
                end
                2'd2: begin
                    out_bytes_reg <= {out_bytes_reg[23:8], in};
                    byte_count <= 2'd0;
                    state <= 1'b0;
                end
            endcase
        end
    end
end

endmodule