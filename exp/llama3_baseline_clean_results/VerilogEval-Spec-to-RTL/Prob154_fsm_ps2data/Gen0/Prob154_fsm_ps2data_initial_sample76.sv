module TopModule(
    input clk,
    input reset,
    input [7:0] in,
    output [23:0] out_bytes,
    output done
);

reg [23:0] out_bytes_reg;
reg done_reg;
reg [1:0] byte_count;
reg [7:0] byte_1, byte_2, byte_3;

always @(*) begin
    out_bytes = out_bytes_reg;
    done = done_reg;
end

always @(posedge clk) begin
    if (reset) begin
        byte_count <= 0;
        byte_1 <= 0;
        byte_2 <= 0;
        byte_3 <= 0;
        out_bytes_reg <= 0;
        done_reg <= 0;
    end else begin
        case (byte_count)
            0: begin
                if (in[3] == 1) begin
                    byte_1 <= in;
                    byte_count <= byte_count + 1;
                end else begin
                    byte_count <= 0;
                end
                done_reg <= 0;
            end
            1: begin
                byte_2 <= in;
                byte_count <= byte_count + 1;
                done_reg <= 0;
            end
            2: begin
                byte_3 <= in;
                byte_count <= 0;
                done_reg <= 1;
            end
            default: begin
                byte_count <= 0;
                done_reg <= 0;
            end
        endcase

        if (done_reg) begin
            out_bytes_reg <= {byte_1, byte_2, byte_3};
        end
    end
end

endmodule