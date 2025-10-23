module TopModule (
    input clk,
    input reset,
    input [7:0] in,
    output reg done
);

    reg [1:0] cnt;
    wire counting = (cnt != 0) || in[3];  // Enable counter when in message or starting new one

    always @(posedge clk) begin
        if (reset) begin
            cnt <= 2'b0;
            done <= 1'b0;
        end else begin
            done <= (cnt[1] && !cnt[0]);  // Assert done when cnt == 2'b10
            
            if (counting) begin
                if (cnt == 2'b0) begin
                    cnt <= {1'b0, in[3]};  // Start counting if in[3]=1, else stay at 0
                end else begin
                    cnt <= cnt + 1'b1;     // Simple increment with automatic wrap-around
                end
            end
        end
    end

endmodule