module TopModule (
    input clk,
    input reset,
    input [7:0] in,
    output reg done
);

    reg [1:0] cnt;
    wire cnt_en = (cnt != 0) || in[3];  // Enable counter when active or starting

    always @(posedge clk) begin
        if (reset) begin
            cnt <= 2'b0;
            done <= 1'b0;
        end else begin
            done <= cnt[1] & ~cnt[0];  // Assert done when cnt == 2'b10
            
            if (cnt_en) begin
                if (cnt == 2'b10)
                    cnt <= 2'b0;  // Wrap around after third byte
                else if (cnt != 0 || in[3])
                    cnt <= cnt + 1'b1;  // Increment when active or starting
            end
        end
    end

endmodule