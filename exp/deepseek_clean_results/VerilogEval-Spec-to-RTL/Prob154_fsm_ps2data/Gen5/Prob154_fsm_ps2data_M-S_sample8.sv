module TopModule (
    input clk,
    input reset,
    input [7:0] in,
    output reg [23:0] out_bytes,
    output reg done
);

    reg [1:0] byte_cnt; // Tracks which byte we're collecting (0-2)

    always @(posedge clk) begin
        if (reset) begin
            byte_cnt <= 2'b0;
            out_bytes <= 24'b0;
            done <= 1'b0;
        end else begin
            done <= 1'b0;
            
            if (byte_cnt == 2'b0) begin
                if (in[3]) begin
                    out_bytes[23:16] <= in;
                    byte_cnt <= 2'b01;
                end
            end else if (byte_cnt == 2'b01) begin
                out_bytes[15:8] <= in;
                byte_cnt <= 2'b10;
            end else begin // byte_cnt == 2'b10
                out_bytes[7:0] <= in;
                done <= 1'b1;
                byte_cnt <= 2'b0;
            end
        end
    end

endmodule