module TopModule(
    input clk,
    input reset,
    input [7:0] in,
    output reg [23:0] out_bytes,
    output reg done
);

reg [1:0] byte_count;
reg [1:0] next_byte_count;
reg [23:0] next_out_bytes;

always @(posedge clk) begin
    if (reset) begin
        byte_count <= 0;
        out_bytes <= 0;
        done <= 0;
    end else begin
        byte_count <= next_byte_count;
        out_bytes <= next_out_bytes;
        done <= (byte_count == 2);
    end
end

assign next_byte_count = (byte_count == 0 && in[3]) ? 1 :
                          (byte_count == 1) ? 2 :
                          (byte_count == 2) ? 0 : byte_count;

assign next_out_bytes = (byte_count == 0 && in[3]) ? {in, 16'd0} :
                         (byte_count == 1) ? {out_bytes[23:8], in} :
                         (byte_count == 2) ? {out_bytes[23:8], in} : out_bytes;

endmodule