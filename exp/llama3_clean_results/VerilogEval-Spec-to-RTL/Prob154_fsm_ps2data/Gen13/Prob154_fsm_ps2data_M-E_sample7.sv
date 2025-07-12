module TopModule(
    input clk,
    input reset,
    input [7:0] in,
    output reg [23:0] out_bytes,
    output reg done
);

reg [1:0] byte_count;
reg [23:0] message;

always @(posedge clk) begin
    if (reset) begin
        byte_count <= 2'b00;
        message <= 24'b0;
        done <= 1'b0;
    end else begin
        if (in[3] == 1'b1) begin
            message[23:16] <= in;
            byte_count <= 2'b01;
        end else if (byte_count == 2'b01) begin
            message[15:8] <= in;
            byte_count <= 2'b10;
        end else if (byte_count == 2'b10) begin
            message[7:0] <= in;
            byte_count <= 2'b00;
            done <= 1'b1;
            out_bytes <= message;
        end
        if (byte_count != 2'b10) begin
            done <= 1'b0;
        end
    end
end

endmodule