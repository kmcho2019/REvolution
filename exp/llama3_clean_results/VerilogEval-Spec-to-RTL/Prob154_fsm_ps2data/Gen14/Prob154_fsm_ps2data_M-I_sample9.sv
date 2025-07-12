module TopModule(
    input clk,
    input reset,
    input [7:0] in,
    output reg [23:0] out_bytes,
    output reg done
);

reg [1:0] byte_count;
reg [23:0] out_bytes_next;

always @(posedge clk) begin
    if (reset) begin
        byte_count <= 2'b00;
        out_bytes <= 24'b0;
        done <= 1'b0;
    end else begin
        case (byte_count)
            2'b00: begin
                if (in[3] == 1'b1) begin
                    out_bytes_next[23:16] <= in;
                    out_bytes_next[15:0] <= 16'b0;
                    byte_count <= 2'b01;
                end else begin
                    byte_count <= 2'b00;
                end
                done <= 1'b0;
            end
            2'b01: begin
                out_bytes_next[15:8] <= in;
                byte_count <= 2'b10;
                done <= 1'b0;
            end
            2'b10: begin
                out_bytes_next[7:0] <= in;
                byte_count <= 2'b00;
                done <= 1'b1;
            end
            default: begin
                byte_count <= 2'b00;
                done <= 1'b0;
            end
        endcase
        out_bytes <= out_bytes_next;
    end
end

endmodule