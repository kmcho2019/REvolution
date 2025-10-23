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
        if (byte_count == 0 && in[3]) begin
            byte_count <= 1;
            out_bytes[23:16] <= in;
        end else if (byte_count == 1) begin
            byte_count <= 2;
            out_bytes[15:8] <= in;
        end else if (byte_count == 2) begin
            byte_count <= 0;
            out_bytes[7:0] <= in;
        end
    end
end

assign done = (byte_count == 2);

endmodule