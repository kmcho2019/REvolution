module TopModule(
    input clk,
    input reset,
    input [7:0] in,
    output reg [23:0] out_bytes,
    output reg done
);

reg [1:0] byte_count;
reg [23:0] out_bytes_reg;

always @(posedge clk) begin
    if (reset) begin
        byte_count <= 0;
        out_bytes_reg <= 0;
        done <= 0;
    end else begin
        case (byte_count)
            0: begin
                if (in[3]) begin
                    byte_count <= 1;
                    out_bytes_reg[23:16] <= in;
                end
                done <= 0;
            end
            1: begin
                byte_count <= 2;
                out_bytes_reg[15:8] <= in;
                done <= 0;
            end
            2: begin
                byte_count <= 0;
                out_bytes_reg[7:0] <= in;
                done <= 1;
            end
        endcase
    end
    out_bytes <= out_bytes_reg;
end

endmodule