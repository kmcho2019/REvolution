module TopModule (
    input clk,
    input reset,
    input [7:0] in,
    output reg [23:0] out_bytes,
    output reg done
);

    reg [1:0] cnt;  // 0: waiting, 1: first byte, 2: second byte
    reg [23:0] msg_reg;

    always @(posedge clk) begin
        if (reset) begin
            cnt <= 2'b0;
            done <= 1'b0;
            out_bytes <= 24'bx;
        end else begin
            done <= 1'b0;
            
            if (cnt == 0) begin
                if (in[3]) begin
                    msg_reg[23:16] <= in;
                    cnt <= 1;
                end
            end else if (cnt == 1) begin
                msg_reg[15:8] <= in;
                cnt <= 2;
            end else begin // cnt == 2
                msg_reg[7:0] <= in;
                out_bytes <= msg_reg;
                done <= 1'b1;
                cnt <= 0;
            end
        end
    end

endmodule