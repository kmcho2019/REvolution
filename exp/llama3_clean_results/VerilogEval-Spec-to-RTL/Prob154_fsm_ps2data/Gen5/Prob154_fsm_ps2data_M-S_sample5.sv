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
        byte_count <= 0;
        out_bytes <= 0;
        done <= 0;
    end else begin
        case (byte_count)
            0: begin
                if (in[3]) begin
                    byte_count <= 1;
                    out_bytes[23:16] <= in;
                end
            end
            1: begin
                byte_count <= 2;
                out_bytes[15:8] <= in;
            end
            2: begin
                byte_count <= 0;
                out_bytes[7:0] <= in;
                done <= 1;
            end
            default: begin
                byte_count <= byte_count;
                out_bytes <= out_bytes;
                done <= 0;
            end
        endcase
    end
end

endmodule