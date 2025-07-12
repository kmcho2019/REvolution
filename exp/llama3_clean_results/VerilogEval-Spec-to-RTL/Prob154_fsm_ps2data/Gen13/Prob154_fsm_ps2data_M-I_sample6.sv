module TopModule(
    input clk,
    input reset,
    input [7:0] in,
    output reg [23:0] out_bytes,
    output reg done
);

reg [1:0] byte_count;
reg clk_enable;

always @(posedge clk) begin
    if (reset) begin
        byte_count <= 0;
        out_bytes <= 0;
        done <= 0;
        clk_enable <= 0;
    end else if (clk_enable) begin
        case (byte_count)
            0: begin
                if (in[3]) begin
                    byte_count <= 1;
                    out_bytes[23:16] <= in;
                    clk_enable <= 1;
                end else begin
                    byte_count <= 0;
                    clk_enable <= 0;
                end
                done <= 0;
            end
            1: begin
                byte_count <= 2;
                out_bytes[15:8] <= in;
                clk_enable <= 1;
                done <= 0;
            end
            2: begin
                byte_count <= 0;
                out_bytes[7:0] <= in;
                clk_enable <= 0;
                done <= 1;
            end
            default: begin
                byte_count <= 0;
                done <= 0;
            end
        endcase
    end
end

endmodule