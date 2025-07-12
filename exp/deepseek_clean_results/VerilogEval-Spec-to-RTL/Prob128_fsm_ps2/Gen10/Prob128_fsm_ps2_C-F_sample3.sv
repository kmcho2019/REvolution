module TopModule (
    input clk,
    input reset,
    input [7:0] in,
    output reg done
);

    reg [1:0] cnt;
    wire counter_enable = (cnt != 0) || in[3];  // Only enable when counting or starting

    always @(posedge clk) begin
        if (reset) begin
            cnt <= 2'b0;
            done <= 1'b0;
        end else begin
            // Assert done one cycle after third byte is received
            done <= (cnt == 2'b10);
            
            if (counter_enable) begin
                if (cnt == 2'b0) begin
                    cnt <= 2'b01;  // Start new message
                end else begin
                    cnt <= cnt + 1'b1;  // Simple increment with automatic wrap-around
                end
            end
        end
    end

endmodule