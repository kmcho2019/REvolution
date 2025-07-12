module TopModule (
    input clk,
    input reset,
    input [7:0] in,
    output reg done
);

    reg [1:0] cnt;
    reg next_done;

    always @(posedge clk) begin
        if (reset) begin
            cnt <= 2'b0;
            done <= 1'b0;
        end else begin
            done <= next_done;
            
            if (cnt == 2'b0) begin
                next_done <= 1'b0;
                if (in[3]) cnt <= 2'b01;  // Start new message
            end else begin
                next_done <= (cnt == 2'b01);  // Pre-calculate done
                cnt <= cnt + 1'b1;  // Will auto-wrap from 3 to 0
            end
        end
    end

endmodule