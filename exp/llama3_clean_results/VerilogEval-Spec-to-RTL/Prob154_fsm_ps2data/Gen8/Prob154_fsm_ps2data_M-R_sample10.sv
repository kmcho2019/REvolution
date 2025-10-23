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
            2'b00: begin
                if (in[3] == 1'b1) begin
                    next_out_bytes <= {in, 24'd0};
                    byte_count <= 2'b01;
                end else begin
                    next_out_bytes <= out_bytes;
                    byte_count <= 2'b00;
                end
            end
            2'b01: begin
                next_out_bytes <= {out_bytes[15:0], in};
                byte_count <= 2'b10;
            end
            2'b10: begin
                next_out_bytes <= {out_bytes[7:0], in, 8'd0};
                byte_count <= 2'b00;
            end
            default: begin
                next_out_bytes <= out_bytes;
                byte_count <= 2'b00;
            end
        endcase
        out_bytes <= next_out_bytes;
    end
end

assign done = (byte_count == 2'b10);

endmodule