module TopModule(
    input clk,
    input reset,
    input [7:0] in,
    output reg [23:0] out_bytes,
    output reg done
);

reg [2:0] byte_count; // One-hot encoding

always @(posedge clk) begin
    if (reset) begin
        byte_count <= 3'b001;
        out_bytes <= 24'b0;
        done <= 1'b0;
    end else begin
        case (byte_count)
            3'b001: begin
                if (in[3] == 1'b1) begin
                    out_bytes[23:16] <= in;
                    byte_count <= 3'b010;
                end else begin
                    byte_count <= 3'b001;
                end
                done <= 1'b0;
            end
            3'b010: begin
                out_bytes[15:8] <= in;
                byte_count <= 3'b100;
                done <= 1'b0;
            end
            3'b100: begin
                out_bytes[7:0] <= in;
                byte_count <= 3'b001;
                done <= 1'b1;
            end
            default: begin
                byte_count <= 3'b001;
                done <= 1'b0;
            end
        endcase
    end
end

endmodule