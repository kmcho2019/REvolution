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
            0: begin
                if (in[3]) begin
                    byte_count <= 1;
                end else begin
                    byte_count <= 0;
                end
            end
            1: begin
                byte_count <= 2;
            end
            2: begin
                byte_count <= 0;
            end
            default: begin
                byte_count <= 0;
            end
        endcase
    end
end

always @(posedge clk) begin
    if (reset) begin
        out_bytes <= 0;
        done <= 0;
    end else begin
        case (byte_count)
            0: begin
                if (in[3]) begin
                    next_out_bytes[23:16] <= in;
                    out_bytes <= {in, 16'd0};
                end else begin
                    out_bytes <= out_bytes;
                end
                done <= 0;
            end
            1: begin
                next_out_bytes[15:8] <= in;
                out_bytes <= {out_bytes[23:8], in};
                done <= 0;
            end
            2: begin
                next_out_bytes[7:0] <= in;
                out_bytes <= {out_bytes[23:8], in};
                done <= 1;
            end
            default: begin
                out_bytes <= out_bytes;
                done <= 0;
            end
        endcase
    end
end

assign done = (byte_count == 2)? 1 : 0;

endmodule