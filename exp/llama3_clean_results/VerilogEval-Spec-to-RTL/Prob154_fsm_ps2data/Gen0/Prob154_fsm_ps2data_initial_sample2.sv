module TopModule(
    input clk,
    input reset,
    input [7:0] in,
    output [23:0] out_bytes,
    output done
);

reg [23:0] out_bytes_reg;
reg [1:0] byte_count_reg;
reg done_reg;

always @(*) begin
    done = done_reg;
    out_bytes = out_bytes_reg;
end

always @(posedge clk) begin
    if (reset) begin
        out_bytes_reg <= 24'b0;
        byte_count_reg <= 2'b0;
        done_reg <= 1'b0;
    end else begin
        case (byte_count_reg)
            2'b00: begin
                if (in[3] == 1'b1) begin
                    out_bytes_reg[23:16] <= in;
                    byte_count_reg <= 2'b01;
                end else begin
                    byte_count_reg <= 2'b00;
                end
                done_reg <= 1'b0;
            end
            2'b01: begin
                out_bytes_reg[15:8] <= in;
                byte_count_reg <= 2'b10;
                done_reg <= 1'b0;
            end
            2'b10: begin
                out_bytes_reg[7:0] <= in;
                byte_count_reg <= 2'b00;
                done_reg <= 1'b1;
            end
            default: begin
                byte_count_reg <= 2'b00;
                done_reg <= 1'b0;
            end
        endcase
    end
end

endmodule