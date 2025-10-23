module TopModule (
    input clk,
    input reset,
    input [7:0] in,
    output reg done
);

    reg [1:0] cnt;

    always @(posedge clk) begin
        if (reset) begin
            cnt <= 2'b0;
            done <= 1'b0;
        end else begin
            // Optimized done signal - asserted when cnt will wrap
            done <= (cnt == 2'b10);
            
            // Efficient counter update with wrap-around
            if (cnt == 2'b0) begin
                cnt <= in[3] ? 2'b01 : 2'b00;  // Only check in[3] when needed
            end else begin
                cnt <= cnt + 1'b1;  // Simple increment (auto-wraps from 3 to 0)
            end
        end
    end

endmodule