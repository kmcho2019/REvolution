module TopModule (
    input clk,
    input reset,
    input [7:0] in,
    output reg done
);

    reg [1:0] cnt;
    wire cnt_en = (cnt != 0) | in[3];  // Enable counter when in message or starting new message

    always @(posedge clk) begin
        if (reset) begin
            cnt <= 2'b0;
            done <= 1'b0;
        end else begin
            done <= (cnt[1] & ~cnt[0]);  // Assert done when cnt == 2'b10
            
            if (cnt_en) begin
                if (cnt == 2'b0) begin
                    cnt <= in[3] ? 2'b01 : 2'b0;  // Start new message only if in[3]=1
                end else begin
                    cnt <= cnt + 1'b1;  // Simple increment with automatic wrap-around
                end
            end
        end
    end

endmodule