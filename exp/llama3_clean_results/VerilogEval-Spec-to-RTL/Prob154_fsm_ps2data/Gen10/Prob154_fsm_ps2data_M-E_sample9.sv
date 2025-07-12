module TopModule(
    input clk,
    input reset,
    input [7:0] in,
    output reg [23:0] out_bytes,
    output reg done
);

reg [1:0] byte_count;

always @(posedge clk) begin
    if (reset) begin
        byte_count <= 2'b00;
        out_bytes <= 24'b0;
        done <= 1'b0;
    end else begin
        if (in[3] == 1'b1) begin
            byte_count <= 2'b01;
            out_bytes[23:16] <= in;
        end else if (byte_count == 2'b01) begin
            byte_count <= 2'b10;
            out_bytes[15:8] <= in;
        end else if (byte_count == 2'b10) begin
            byte_count <= 2'b11;
            out_bytes[7:0] <= in;
            done <= 1'b1;
        end else if (byte_count == 2'b11) begin
            byte_count <= 2'b00;
            done <= 1'b0;
        end
    end
end

endmodule