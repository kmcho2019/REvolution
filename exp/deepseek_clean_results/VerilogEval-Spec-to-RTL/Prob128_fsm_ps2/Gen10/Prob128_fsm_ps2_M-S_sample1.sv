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
            done <= (cnt == 2'b10);  // Directly assign done
            
            if (cnt == 2'b0) begin
                if (in[3]) cnt <= 2'b01;  // Start new message when in[3]=1
            end else begin
                cnt <= (cnt == 2'b10) ? 2'b0 : cnt + 1'b1;
            end
        end
    end

endmodule