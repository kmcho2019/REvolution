module TopModule(
    input clk,
    input reset,
    input [7:0] in,
    output reg [23:0] out_bytes,
    output reg done
);

reg [1:0] byte_count;
reg [1:0] next_byte_count;

always @(posedge clk) begin
    if (reset) begin
        byte_count <= 0;
        out_bytes <= 0;
        done <= 0;
    end else begin
        byte_count <= next_byte_count;
        case (byte_count)
            0: begin
                if (in[3]) begin
                    out_bytes[23:16] <= in;
                end
                done <= 0;
            end
            1: begin
                out_bytes[15:8] <= in;
                done <= 0;
            end
            2: begin
                out_bytes[7:0] <= in;
                done <= 1;
            end
            default: begin
                done <= 0;
            end
        endcase
    end
end

always @(*) begin
    case (byte_count)
        0: begin
            if (in[3]) begin
                next_byte_count = 1;
            end else begin
                next_byte_count = 0;
            end
        end
        1: begin
            next_byte_count = 2;
        end
        2: begin
            next_byte_count = 0;
        end
        default: begin
            next_byte_count = 0;
        end
    endcase
end

endmodule