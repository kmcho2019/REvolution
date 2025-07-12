module TopModule(
    input clk,
    input reset,
    input [7:0] in,
    output reg [23:0] out_bytes,
    output reg done
);

reg [1:0] byte_count;
reg [23:0] next_out_bytes;

always @(*) begin
    if (byte_count == 2) begin
        done = 1;
    end else begin
        done = 0;
    end
end

always @(posedge clk) begin
    if (reset) begin
        byte_count <= 0;
        out_bytes <= 0;
    end else begin
        case (byte_count)
            0: begin
                if (in[3]) begin
                    byte_count <= 1;
                    out_bytes[23:16] <= in;
                end else begin
                    byte_count <= 0;
                end
            end
            1: begin
                byte_count <= 2;
                out_bytes[15:8] <= in;
            end
            2: begin
                byte_count <= 0;
                out_bytes[7:0] <= in;
            end
            default: begin
                byte_count <= 0;
            end
        endcase
    end
end

endmodule