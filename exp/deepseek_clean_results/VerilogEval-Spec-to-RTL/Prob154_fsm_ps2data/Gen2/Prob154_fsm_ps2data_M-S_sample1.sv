module TopModule (
    input clk,
    input reset,
    input [7:0] in,
    output reg [23:0] out_bytes,
    output reg done
);

    reg [1:0] byte_cnt;
    reg [23:0] msg_buffer;

    always @(posedge clk) begin
        if (reset) begin
            byte_cnt <= 2'b0;
            msg_buffer <= 24'b0;
            done <= 1'b0;
        end else begin
            done <= 1'b0;
            
            if (byte_cnt == 2'b0) begin
                if (in[3]) begin
                    msg_buffer[23:16] <= in;
                    byte_cnt <= 2'b1;
                end
            end else if (byte_cnt == 2'b1) begin
                msg_buffer[15:8] <= in;
                byte_cnt <= 2'b2;
            end else begin // byte_cnt == 2'b2
                msg_buffer[7:0] <= in;
                byte_cnt <= 2'b0;
                done <= 1'b1;
                out_bytes <= msg_buffer;
            end
        end
    end

endmodule