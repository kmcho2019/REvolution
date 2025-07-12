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
            // Optimized done generation using bit pattern
            done <= (cnt == 2'b10);
            
            // Simplified state transitions
            if (cnt == 2'b0) begin
                cnt <= in[3] ? 2'b01 : 2'b0;
            end else begin
                cnt <= cnt + 1'b1;  // Automatically wraps around after 2'b10
            end
        end
    end

endmodule