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
        byte_count <= 0;
        out_bytes <= 0;
        done <= 0;
    end else begin
        case (byte_count)
            0: begin
                if (in[3]) begin
                    out_bytes_next[23:16] <= in;
                    byte_count <= 1;
                end else begin
                    byte_count <= 0;
                end
                done <= 0;
            end
            1: begin
                out_bytes_next[15:8] <= in;
                byte_count <= 2;
                done <= 0;
            end
            2: begin
                out_bytes_next[7:0] <= in;
                byte_count <= 0;
                done <= 1;
            end
            default: begin
                byte_count <= 0;
                done <= 0;
            end
        endcase
        out_bytes <= out_bytes_next;
    end
end

endmodule