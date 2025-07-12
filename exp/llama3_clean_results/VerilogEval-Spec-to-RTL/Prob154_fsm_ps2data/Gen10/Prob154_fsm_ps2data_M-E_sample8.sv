module TopModule(
    input clk,
    input reset,
    input [7:0] in,
    output reg [23:0] out_bytes,
    output reg done
);

reg [1:0] byte_count;
reg [7:0] byte1, byte2, byte3;

always @(posedge clk) begin
    if (reset) begin
        byte_count <= 2'b00;
        byte1 <= 8'b0;
        byte2 <= 8'b0;
        byte3 <= 8'b0;
        out_bytes <= 24'b0;
        done <= 1'b0;
    end else begin
        if (in[3] == 1'b1 && byte_count == 2'b00) begin
            byte1 <= in;
            byte_count <= 2'b01;
        end else if (byte_count == 2'b01) begin
            byte2 <= in;
            byte_count <= 2'b10;
        end else if (byte_count == 2'b10) begin
            byte3 <= in;
            byte_count <= 2'b11;
            done <= 1'b1;
            out_bytes <= {byte1, byte2, byte3};
        end else if (byte_count == 2'b11) begin
            byte_count <= 2'b00;
            done <= 1'b0;
        end
    end
end

endmodule