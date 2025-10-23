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
        byte_count <= 2'b00;
        out_bytes_reg <= 24'b0;
        done <= 1'b0;
    end else begin
        case (byte_count)
            2'b00: begin
                if (in[3] == 1'b1) begin
                    out_bytes_reg[23:16] <= in;
                    byte_count <= 2'b01;
                end else begin
                    byte_count <= 2'b00;
                end
            end
            2'b01: begin
                out_bytes_reg[15:8] <= in;
                byte_count <= 2'b10;
            end
            2'b10: begin
                out_bytes_reg[7:0] <= in;
                byte_count <= 2'b00;
                done <= 1'b1;
            end
            default: begin
                byte_count <= 2'b00;
            end
        endcase
        if (byte_count != 2'b10) begin
            done <= 1'b0;
        end
    end
end

assign out_bytes = out_bytes_reg;

endmodule