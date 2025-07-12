module TopModule (
    input clk,
    input reset,
    input [7:0] in,
    output reg [23:0] out_bytes,
    output reg done
);

    reg [1:0] byte_cnt;

    always @(posedge clk) begin
        if (reset) begin
            byte_cnt <= 2'b0;
            done <= 1'b0;
            out_bytes <= 24'bx;
        end else begin
            done <= 1'b0;
            
            if (byte_cnt == 0) begin
                if (in[3]) begin
                    out_bytes[23:16] <= in;
                    byte_cnt <= 2'b1;
                end
            end else begin
                case (byte_cnt)
                    2'b01: out_bytes[15:8] <= in;
                    2'b10: begin
                        out_bytes[7:0] <= in;
                        done <= 1'b1;
                    end
                endcase
                byte_cnt <= byte_cnt + 1;
            end
        end
    end

endmodule