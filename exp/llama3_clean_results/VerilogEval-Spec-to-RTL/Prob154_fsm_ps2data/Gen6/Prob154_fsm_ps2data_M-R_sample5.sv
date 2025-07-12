module TopModule(
    input clk,
    input reset,
    input [7:0] in,
    output reg [23:0] out_bytes,
    output reg done
);

reg [1:0] byte_count;
reg [23:0] next_out_bytes;

always @(posedge clk) begin
    if (reset) begin
        byte_count <= 0;
        out_bytes <= 0;
    end else begin
        case (byte_count)
            0: begin
                if (in[3]) begin
                    byte_count <= 1;
                    out_bytes <= {in, 24'd0};
                end else begin
                    byte_count <= 0;
                    out_bytes <= 0;
                end
            end
            1: begin
                byte_count <= 2;
                out_bytes <= {out_bytes[15:0], in};
            end
            2: begin
                byte_count <= 0;
                out_bytes <= {out_bytes[7:0], in, 8'd0};
            end
        endcase
    end
end

assign done = (byte_count == 2);

endmodule