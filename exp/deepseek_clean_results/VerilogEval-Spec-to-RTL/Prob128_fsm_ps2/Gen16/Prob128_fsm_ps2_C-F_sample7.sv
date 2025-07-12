module TopModule (
    input clk,
    input reset,
    input [7:0] in,
    output reg done
);

    reg [1:0] byte_cnt;
    reg done_next;

    always @(posedge clk) begin
        if (reset) begin
            byte_cnt <= 2'b0;
            done <= 1'b0;
            done_next <= 1'b0;
        end else begin
            done <= done_next;
            done_next <= 1'b0;
            
            if (byte_cnt == 2'b0) begin
                // Wait for start of message
                if (in[3]) begin
                    byte_cnt <= 2'b01;
                end
            end else begin
                // Count through message bytes
                if (byte_cnt == 2'b10) begin
                    byte_cnt <= 2'b0;
                    done_next <= 1'b1;
                end else begin
                    byte_cnt <= byte_cnt + 1'b1;
                end
            end
        end
    end

endmodule