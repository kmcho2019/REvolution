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
                    out_bytes_next = {in, 24'd0};
                    byte_count <= 1;
                    done <= 0;
                end else begin
                    out_bytes_next = out_bytes;
                    byte_count <= 0;
                    done <= 0;
                end
            end
            1: begin
                out_bytes_next = {out_bytes[15:0], in};
                byte_count <= 2;
                done <= 0;
            end
            2: begin
                out_bytes_next = {out_bytes[7:0], in, 8'd0};
                byte_count <= 0;
                done <= 1;
            end
            default: begin
                out_bytes_next = out_bytes;
                byte_count <= 0;
                done <= 0;
            end
        endcase
        out_bytes <= out_bytes_next;
    end
end

endmodule