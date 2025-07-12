module TopModule (
    input clk,
    input reset,
    input [7:0] in,
    output reg done
);

    reg [1:0] cnt;
    wire en = (cnt != 0) || in[3];  // Enable counter during message or when starting

    always @(posedge clk) begin
        if (reset) begin
            cnt <= 2'b0;
            done <= 1'b0;
        end else begin
            done <= (cnt[1] && !cnt[0]);  // Assert done when cnt==2
            
            if (en) begin
                if (cnt == 2'b0) begin
                    cnt <= in[3] ? 2'b01 : 2'b0;  // Start only if in[3]=1
                end else begin
                    cnt <= cnt + 1'b1;  // Will automatically wrap from 2->0
                end
            end
        end
    end

endmodule