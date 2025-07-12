module TopModule (
    input clk,
    input reset,
    input [7:0] in,
    output reg done
);

    reg [1:0] cnt;
    wire cnt_will_wrap;

    assign cnt_will_wrap = (cnt == 2'b10);

    always @(posedge clk) begin
        if (reset) begin
            cnt <= 2'b0;
            done <= 1'b0;
        end else begin
            // Pre-calculate done for next cycle
            done <= cnt_will_wrap;
            
            // Update counter
            if (cnt == 2'b0) begin
                cnt <= in[3] ? 2'b01 : 2'b00;
            end else begin
                cnt <= cnt + 1'b1;  // Will automatically wrap from 3 to 0
            end
        end
    end

endmodule