module TopModule (
    input clk,
    input reset,
    input [7:0] in,
    output reg done
);

    reg [1:0] cnt;
    wire start_new = (cnt == 2'b0) & in[3];
    wire continue_msg = (cnt != 2'b0);

    always @(posedge clk) begin
        if (reset) begin
            cnt <= 2'b0;
            done <= 1'b0;
        end else begin
            // Registered done signal for better timing
            done <= (cnt == 2'b10);
            
            // Update counter only when needed
            if (start_new || continue_msg) begin
                cnt <= (cnt == 2'b10) ? 2'b0 : (cnt + 1'b1);
            end
        end
    end

endmodule