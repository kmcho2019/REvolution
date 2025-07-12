module TopModule(
    input clk,
    input reset,
    input [7:0] in,
    output reg [23:0] out_bytes,
    output reg done
);

reg [1:0] byte_count;
reg [7:0] byte1, byte2;

always @(posedge clk) begin
    if (reset) begin
        byte_count <= 0;
        out_bytes <= 0;
        byte1 <= 0;
        byte2 <= 0;
        done <= 0;
    end else begin
        case (byte_count)
            2'b00: begin
                if (in[3]) begin
                    byte1 <= in;
                    byte_count <= 2'b01;
                end
                done <= 0;
            end
            2'b01: begin
                byte2 <= in;
                byte_count <= 2'b10;
                done <= 0;
            end
            2'b10: begin
                out_bytes <= {byte1, byte2, in};
                byte_count <= 2'b00;
                done <= 1;
            end
            default: begin
                byte_count <= 2'b00;
                done <= 0;
            end
        endcase
    end
end

endmodule